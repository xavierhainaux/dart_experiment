import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:vector_math/vector_math.dart';

ImageElement image;

Future main() async {
  image = await loadImage("images/g1.jpg");

  new Renderer()..render();
}

Future<ImageElement> loadImage(String imagePath) async {
  Completer completer = new Completer<ImageElement>();

  ImageElement image = new Element.tag('img');
  image.src = imagePath;

  image.onLoad.listen((e) {
    completer.complete(image);
  });

  return completer.future;
}

class Renderer {
  webgl.RenderingContext gl;

  int _viewportWidth, _viewportHeight;

  webgl.Texture _g1Texture;

  webgl.Buffer _vertexTextureCoordinateBuffer;
  webgl.Buffer _vertexPositionBuffer;
  webgl.Buffer _vertexIndexBuffer;

  Matrix4 _pMatrix;
  Matrix4 _mvMatrix;

  int _aVertexPosition;
  int _aVertexTextureCoordinate;

  webgl.UniformLocation _uPMatrix;
  webgl.UniformLocation _uMVMatrix;
  webgl.UniformLocation _samplerUniform;

  double _xRot = 0.0;
  double _yRot = 0.0;
  double _zRot = 0.0;
  double _lastTime = 0.0;

  Renderer() {
    CanvasElement canvas = new CanvasElement(width:1280, height:720); //canvas internal resolution
    document.body.children.add(canvas);

    initGL(canvas);

    _viewportWidth = canvas.width;
    _viewportHeight = canvas.height;

    _mvMatrix = new Matrix4.identity();
    _pMatrix = new Matrix4.identity();

    _initShaders();
    _initBuffers();
    _initTexture();

    gl.clearColor(0.2, 0.2, 0.2, 1.0);
    gl.enable(webgl.RenderingContext.DEPTH_TEST);

    window..onResize.listen((dynamic event){
      resizeCanvas();
    });
  }

  void initGL(CanvasElement canvas) {
    try {
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "This context is not defined."; }
    } catch (error) {
      throw "Your web browser does not support WebGL!";
    }
  }

  void resizeCanvas() {
    var realToCSSPixels = window.devicePixelRatio;

    var displayWidth  = (gl.canvas.clientWidth  * realToCSSPixels).floor();
    var displayHeight = (gl.canvas.clientHeight * realToCSSPixels).floor();

    // Check if the canvas is not the same size.
    if (gl.canvas.width != displayWidth || gl.canvas.height != displayHeight) {
      // Make the canvas the same size
      gl.canvas.width = displayWidth;
      gl.canvas.height = displayHeight;

      gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
    }
  }

  void _initShaders() {
    // vertex shader source code. uPosition is our variable that we'll
    // use to create animation
    String vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;
  
    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;
  
    varying vec2 vTextureCoord;
  
    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
    }
    """;

    // fragment shader source code. uColor is our variable that we'll
    // use to animate color
    String fsSource = """
    precision mediump float;

    uniform sampler2D uSampler;
    
    varying vec2 vTextureCoord;

    void main(void) {
      gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
    }
    """;

    // vertex shader compilation
    webgl.Shader vs = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vsSource);
    gl.compileShader(vs);

    // fragment shader compilation
    webgl.Shader fs = gl.createShader(webgl.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fsSource);
    gl.compileShader(fs);

    // attach shaders to a WebGL program
    webgl.Program _shaderProgram = gl.createProgram();
    gl.attachShader(_shaderProgram, vs);
    gl.attachShader(_shaderProgram, fs);
    gl.linkProgram(_shaderProgram);
    gl.useProgram(_shaderProgram);

    /**
     * Check if shaders were compiled properly. This is probably the most painful part
     * since there's no way to "debug" shader compilation
     */
    if (!gl.getShaderParameter(vs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(vs));
    }

    if (!gl.getShaderParameter(fs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(fs));
    }

    if (!gl.getProgramParameter(_shaderProgram, webgl.RenderingContext.LINK_STATUS)) {
      print(gl.getProgramInfoLog(_shaderProgram));
    }

    _aVertexPosition = gl.getAttribLocation(_shaderProgram, "aVertexPosition");
    gl.enableVertexAttribArray(_aVertexPosition);

    _aVertexTextureCoordinate = gl.getAttribLocation(_shaderProgram, "aTextureCoord");
    gl.enableVertexAttribArray(_aVertexTextureCoordinate);

    _uPMatrix = gl.getUniformLocation(_shaderProgram, "uPMatrix");
    _uMVMatrix = gl.getUniformLocation(_shaderProgram, "uMVMatrix");
    _samplerUniform = gl.getUniformLocation(_shaderProgram, "uSampler");

  }

  void _initBuffers() {
    // variables to store vertices, texture coordinates
    List<double> vertices, textureCoords;

    // create square
    _vertexPositionBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    // fill "current buffer" with triangle verticies
    vertices = [
      // Front face
      -1.0, -1.0,  1.0,
      1.0, -1.0,  1.0,
      1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,

      // Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0, -1.0, -1.0,

      // Top face
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0,

      // Bottom face
      -1.0, -1.0, -1.0,
      1.0, -1.0, -1.0,
      1.0, -1.0,  1.0,
      -1.0, -1.0,  1.0,

      // Right face
      1.0, -1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0,  1.0,  1.0,
      1.0, -1.0,  1.0,

      // Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0,
    ];
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), webgl.RenderingContext.STATIC_DRAW);

    _vertexTextureCoordinateBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, _vertexTextureCoordinateBuffer);
    textureCoords = [
      // Front face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,

      // Back face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      // Top face
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      // Bottom face
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,

      // Right face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      // Left face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
    ];
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(textureCoords), webgl.RenderingContext.STATIC_DRAW);

    _vertexIndexBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndexBuffer);
    List<int> _cubeVertexIndices = [
      0,  1,  2,    0,  2,  3, // Front face
      4,  5,  6,    4,  6,  7, // Back face
      8,  9, 10,    8, 10, 11, // Top face
      12, 13, 14,   12, 14, 15, // Bottom face
      16, 17, 18,   16, 18, 19, // Right face
      20, 21, 22,   20, 22, 23  // Left face
    ];
    gl.bufferData(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(_cubeVertexIndices), webgl.RenderingContext.STATIC_DRAW);
  }

  void _initTexture() {
    _g1Texture = gl.createTexture();
    _handleLoadedTexture(_g1Texture, image);
  }

  void _handleLoadedTexture(webgl.Texture texture, ImageElement img) {
    gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, texture);
    gl.pixelStorei(webgl.RenderingContext.UNPACK_FLIP_Y_WEBGL, 1); // second argument must be an int
    gl.texImage2D(webgl.RenderingContext.TEXTURE_2D, 0, webgl.RenderingContext.RGBA, webgl.RenderingContext.RGBA, webgl.RenderingContext.UNSIGNED_BYTE, img);
    gl.texParameteri(webgl.RenderingContext.TEXTURE_2D, webgl.RenderingContext.TEXTURE_MAG_FILTER, webgl.RenderingContext.NEAREST);
    gl.texParameteri(webgl.RenderingContext.TEXTURE_2D, webgl.RenderingContext.TEXTURE_MIN_FILTER, webgl.RenderingContext.NEAREST);
    gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, null);
  }

  void _setMatrixUniforms() {
    Float32List tmpList = new Float32List(16);

    _pMatrix.copyIntoArray(tmpList);
    gl.uniformMatrix4fv(_uPMatrix, false, tmpList);

    _mvMatrix.copyIntoArray(tmpList);
    gl.uniformMatrix4fv(_uMVMatrix, false, tmpList);
  }

  void render({num time : 0.0}) {
    update(time);
    draw();

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  void update(double time) {
    if (_lastTime != 0) {
      double animationStep = time - _lastTime;

      _xRot += (90 * animationStep) / 2000.0;
      _yRot += (90 * animationStep) / 2000.0;
      _zRot += (90 * animationStep) / 2000.0;
    }
    _lastTime = time;
  }

  void draw() {
    gl.viewport(0, 0, _viewportWidth, _viewportHeight);
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT | webgl.RenderingContext.DEPTH_BUFFER_BIT);

    // field of view is 45°, width-to-height ratio, hide things closer than 0.1 or further than 100
//    Matrix4.perspective(45, _viewportWidth / _viewportHeight, 0.1, 100.0, _pMatrix);
    _pMatrix = makePerspectiveMatrix(radians(45.0), _viewportWidth / _viewportHeight, 0.1, 100.0);

    _mvMatrix = new Matrix4.identity();
    _mvMatrix.translate(new Vector3(0.0, 0.0, -5.0));

    _mvMatrix.rotate(new Vector3(1.0, 0.0, 0.0), radians(_xRot));
    _mvMatrix.rotate(new Vector3(0.0, 1.0, 0.0), radians(_yRot));
    _mvMatrix.rotate(new Vector3(0.0, 0.0, 1.0), radians(_zRot));

    // verticies
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, _vertexPositionBuffer);
    gl.vertexAttribPointer(_aVertexPosition, 3, webgl.RenderingContext.FLOAT, false, 0, 0);

    // texture
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, _vertexTextureCoordinateBuffer);
    gl.vertexAttribPointer(_aVertexTextureCoordinate, 2, webgl.RenderingContext.FLOAT, false, 0, 0);

    gl.activeTexture(webgl.RenderingContext.TEXTURE0);
    gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, _g1Texture);
    gl.uniform1i(_samplerUniform, 0);

    gl.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, _vertexIndexBuffer);
    _setMatrixUniforms();
    gl.drawElements(webgl.RenderingContext.TRIANGLES, 36, webgl.RenderingContext.UNSIGNED_SHORT, 0);
  }

}

