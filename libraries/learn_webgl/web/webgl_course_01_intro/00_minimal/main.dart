import 'dart:html';
import 'dart:web_gl' as webgl;

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);

  webgl.RenderingContext gl = canvas.getContext3d();

  gl.clearColor(1.0, 0.0, 0.0, 1.0);
  gl.clear(webgl.COLOR_BUFFER_BIT);
}
