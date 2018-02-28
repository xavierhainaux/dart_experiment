import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

Future main() async {
  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;

  List<double> vertices = [
    0.0, 0.0, 0.0,
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0
  ];
  int elementsByVertices = 3;
  int get vertexCount => vertices.length ~/ elementsByVertices;

  String vertexShaderSource = '''
    attribute vec3 aVertexPosition;

    void main() {
      gl_Position = vec4(aVertexPosition, 1.0);
    }
  ''';

  String fragmentShaderSource = '''
    void main() {
      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
    }
  ''';

  Renderer(){
    CanvasElement canvas = new CanvasElement(width:800, height:800); //canvas internal resolution
    document.body.children.add(canvas);

    initGL(canvas);
    initProgram();

    gl.clearColor(0.8, 0.8, 0.8, 1);
  }

  void initGL(CanvasElement canvas) {
    try {
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "This context is not defined."; }
    } catch (error) {
      throw "Your web browser does not support WebGL!";
    }
  }

  void initProgram() {
    webgl.Program program = buildProgram(vertexShaderSource,fragmentShaderSource);
    gl.useProgram(program);
    setupAttribut(program, "aVertexPosition", elementsByVertices , vertices);
  }

  webgl.Program buildProgram(String vs, String fs) {
    webgl.Program program = gl.createProgram();

    webgl.Shader vertexShader = createShader(webgl.RenderingContext.VERTEX_SHADER, vs);
    gl.attachShader(program, vertexShader);

    webgl.Shader fragmentShader = createShader(webgl.RenderingContext.FRAGMENT_SHADER, fs);
    gl.attachShader(program, fragmentShader);

    gl.linkProgram(program);
    gl.validateProgram(program);

    if (gl.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS) == null) {
      String info = gl.getProgramInfoLog(program);
      throw "Could not compile the shader program: \n\n $info";
    }

    return program;
  }

  webgl.Shader createShader(int shaderType, String shaderSource) {
    webgl.Shader shader = gl.createShader(shaderType);

    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);

    if (gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS) == null) {
      String info = gl.getShaderInfoLog(shader);
      throw "Could not compile $shaderType shader:\n\n $info";
    }

    return shader;
  }

  void setupAttribut(webgl.Program program, String attributName, int rsize, List<double> vertexList) {
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertexList),
        webgl.RenderingContext.STATIC_DRAW);
    int attributLocation = gl.getAttribLocation(program, attributName);
    gl.enableVertexAttribArray(attributLocation);
    gl.vertexAttribPointer(attributLocation, rsize, webgl.RenderingContext.FLOAT, false, 0, 0);
  }

  void render({num time : 0.0}) {
    draw();

    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }

  void draw() {
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);
    gl.drawArrays(webgl.RenderingContext.TRIANGLE_STRIP, 0, vertexCount);
  }
}
