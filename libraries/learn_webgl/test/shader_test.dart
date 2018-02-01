@TestOn("dartium")

import 'package:test/test.dart';
import 'dart:html';
import 'dart:web_gl' as webgl;

void _init() {
}

main() {
    webgl.RenderingContext gl;
    CanvasElement canvas;

  _init();

  setUp(() async {
    canvas = new CanvasElement();
    gl = canvas.getContext3d();
  });

  tearDown(() async {
    gl = null;
    canvas = null;
  });

  group("Shader creation", () {
    test("creation / suppression", () async {
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      expect(shader, isNotNull);
      expect(gl.isShader(shader), true);

      gl.deleteShader(shader);
      /// deleteShader ne le rend pas à null
      expect(shader, isNotNull);
      expect(gl.isShader(shader), false);

      shader = null;
      expect(shader, isNull);


    });
    test("type de shader", () async {
      /// Les deux shader possibles sont crées en spécifiant leur type avec VERTEX_SHADER ou FRAGMENT_SHADER
      webgl.Shader vertexShader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      expect(gl.isShader(vertexShader), true);

      webgl.Shader fragmentShader = gl.createShader(webgl.RenderingContext.FRAGMENT_SHADER);
      expect(gl.isShader(fragmentShader), true);

      ///on peut vérifier le type de shader en récupérant des parametres
      int shaderType;

      shaderType = gl.getShaderParameter(vertexShader, webgl.RenderingContext.SHADER_TYPE) as int;
      expect(shaderType, webgl.RenderingContext.VERTEX_SHADER);

      shaderType = gl.getShaderParameter(fragmentShader, webgl.RenderingContext.SHADER_TYPE) as int;
      expect(shaderType, webgl.RenderingContext.FRAGMENT_SHADER);
    });
  });

  group("Shader sources", () {
    test("sources à l'init", () async {
      ///à la base, la source d'un shader est vide
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      String source = gl.getShaderSource(shader);
      expect(source, '');
    });
    test("ajouter des sources", () async {
      ///la source d'un shader est un string
      String source = 'test';
      /// il faut juste l'associer au shader
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, source);

      expect(gl.getShaderSource(shader), source);
    });
    test("ajouter de mauvaises sources et compiler", () async {
      ///mais il faut évidemment que la source soit correcte car le shader doit être compilé avant de pouvoir être utilisé réellement
      String source = 'test';
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, source);

      ///la compilation du shader
      gl.compileShader(shader);

      /// si on vérifie l'état de la compilation, ce n'est pas bon
      bool isCompiled = gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS) as bool;
      expect(isCompiled, false);

      /// on peut aussi le vérifier en récupérant l'erreur
      var error = gl.getShaderInfoLog(shader);

      if (error.length > 0) {
        /// en effet, le contenu n'est pas reconnaissable
        print("l'erreur est attendue : $error"); // error : ERROR: 0:1: 'test' : syntax error
      }
    });
    test("ajouter de bonnes sources et compiler", () async {
      ///par contre, si on passe des sources correctes
      String source = VSS.simple2D;
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, source);

      ///la compilation du shader
      gl.compileShader(shader);

      /// si on vérifie l'état de la compilation, c'est ok
      bool isCompiled = gl.getShaderParameter(shader, webgl.RenderingContext.COMPILE_STATUS) as bool;
      expect(isCompiled, true);

      /// on peut aussi le vérifier en récupérant l'erreur, ça devrait passer
      var error = gl.getShaderInfoLog(shader);

      if (error.length > 0) {
        print('error');
      }else{
        /// en effet, le contenu est correcte pour la compilation
        print('shader compilé');
      }

      //Todo (jpu) :
      // on peut demander le précision des valeurs numériques
      // gl.getShaderPrecisionFormat(webgl.RenderingContext.VERTEX_SHADER, webgl.RenderingContext.MEDIUM_FLOAT);
    });
  });
  group("utiliser un shader", ()
  {
    test("attacher a un program", () async {
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, VSS.simple2D);
      gl.compileShader(shader);

      webgl.Program program = gl.createProgram();


      ///attachement d'un shader au program
      gl.attachShader(program, shader);

      List<webgl.Shader> shaders;

      ///il ets possible de questionner un program pour récupérer ses shaders
      shaders = gl.getAttachedShaders(program);
      expect(shaders.length, 1);

      ///on peut aussi détacher un shader d'un program
      gl.detachShader(program, shader);
      shaders = gl.getAttachedShaders(program);
      expect(shaders.length, 0);
    });
    test("flag delete shader", () async {
      webgl.Shader shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, VSS.simple2D);
      gl.compileShader(shader);

      bool isFlaggedForDeletion;
      /// faire une requete sur le DELETE_STATUS rendra false, car comme le shader n'est pas encore flaggé
      isFlaggedForDeletion = gl.getShaderParameter(shader, webgl.RenderingContext.DELETE_STATUS) as bool;
      expect(isFlaggedForDeletion, false);

      /// faire une requete sur le DELETE_STATUS rendra null, car comme le shader n'était pas utilisé par un program,
      /// il est supprimé directement et n'est plus questionnable
      gl.deleteShader(shader);
      isFlaggedForDeletion = gl.getShaderParameter(shader, webgl.RenderingContext.DELETE_STATUS) as bool;
      expect(isFlaggedForDeletion, null);


      ///Mais si on crée un shader
      shader = gl.createShader(webgl.RenderingContext.VERTEX_SHADER);
      gl.shaderSource(shader, VSS.simple2D);
      gl.compileShader(shader);

      webgl.Program program = gl.createProgram();

      ///et qu'on l'attache a un program
      gl.attachShader(program, shader);

      /// oter que le deleteShader marque le shader comme voulant être supprimé.
      /// si un program l'utilise, il ne sera supprimé que quand le program ne l'utilisera plus
      gl.deleteShader(shader);
      expect(gl.isShader(shader), true);

      /// faire une requete sur le DELETE_STATUS rendra null, car comme le shader n'était pas utilisé par un program,
      /// il a été supprimé directement et n'est plus accessible au requetes de parametre
      isFlaggedForDeletion = gl.getShaderParameter(shader, webgl.RenderingContext.DELETE_STATUS) as bool;
      expect(isFlaggedForDeletion, true);

      ///dés qu'on détache un shader flaggé pour un delete, il est deleté directement
      gl.detachShader(program, shader);
      expect(gl.isShader(shader), false);

    });
  });
}

abstract class VSS {
  //language=glsl
  static const String simple2D = """
    attribute vec2 aVertexPosition;

    uniform mat3 uWorldTransform;

    void main(void)
    {
      gl_Position = vec4(uWorldTransform * vec3(aVertexPosition, 1.0), 1.0);
    }
  """;
}