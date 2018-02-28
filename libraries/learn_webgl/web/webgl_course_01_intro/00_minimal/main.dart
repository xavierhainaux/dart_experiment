import 'dart:html';
import 'dart:web_gl' as webgl;

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);

  webgl.RenderingContext gl = canvas.getContext("experimental-webgl") as webgl.RenderingContext;

  gl.clearColor(1.0, 0.0, 0.0, 1.0);
  gl.clear(webgl.COLOR_BUFFER_BIT);
}