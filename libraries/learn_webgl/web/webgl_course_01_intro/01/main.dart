import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

Future main() async {
  new Renderer()..render();
}

class Renderer{
  webgl.RenderingContext gl;

  List<double> vertices;
  int elementsByVertices;

  String vertexShaderSource = '''
    attribute vec3 aVertexPosition;

    void main() {
      gl_Position = vec4(aVertexPosition, 2.0);
    }
  ''';

  String fragmentShaderSource = '''
    void main() {
      gl_FragColor = vec4(0.5, 0.5, 1.0, 1.0);
    }
  ''';

  webgl.Program program;

  Renderer(){

    initGL();

    vertices = [
      0.0, 0.0, 0.0,
      1.0, 0.0, 0.0,
      0.0, 1.0, 0.0
    ];
    elementsByVertices = 3;

    program = buildProgram(vertexShaderSource,fragmentShaderSource);
    gl.useProgram(program);
    setupAttribut(program, "aVertexPosition", elementsByVertices , vertices);
  }

  void initGL() {
    try {
      CanvasElement canvas = querySelector('#glCanvas') as CanvasElement;
      gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;
      if (gl == null) { throw "x"; }
    } catch (error) {
      throw "Your web browser does not support WebGL!";
    }

    gl.clearColor(0.8, 0.8, 0.8, 1);
  }

  webgl.Program buildProgram(String vs, String fs) {
    webgl.Program program = gl.createProgram();

    createShader(program, 'vertex', vs);
    createShader(program, 'fragment', fs);

    gl.linkProgram(program);
    if (gl.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS) == null) {
      throw "Could not link the shader program!";
    }
    return program;
  }

  void createShader(webgl.Program program, String shaderType, String shaderSource) {
    webgl.Shader shader = gl.createShader((shaderType == 'vertex') ?
    webgl.RenderingContext.VERTEX_SHADER : webgl.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(shader, shaderSource);
    gl.compileShader(shader);
    if (gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS) == null) {
      throw "Could not compile " + shaderType +
          " shader:\n\n"+gl.getShaderInfoLog(shader);
    }
    gl.attachShader(program, shader);
  }

  void setupAttribut(webgl.Program program, String attributName, int rsize, List<double> vertexList) {
    gl.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, gl.createBuffer());
    gl.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertexList),
        webgl.RenderingContext.STATIC_DRAW);
    int attributLocation = gl.getAttribLocation(program, attributName);
    gl.enableVertexAttribArray(attributLocation);
    gl.vertexAttribPointer(attributLocation, rsize, webgl.RenderingContext.FLOAT, false, 0, 0);
  }

  void draw() {
    gl.clear(webgl.RenderingContext.COLOR_BUFFER_BIT);
    gl.drawArrays(webgl.RenderingContext.TRIANGLE_STRIP, 0, vertices.length ~/ elementsByVertices);
  }

  void render({num time : 0.0}) {
    draw();
    window.requestAnimationFrame((num time) {
      this.render(time: time);
    });
  }
}
