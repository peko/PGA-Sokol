#-------------------------------------------------------------------------------
# cube.nim
# Shader with uniform data
#-------------------------------------------------------------------------------
import sokol/gfx as sg
import sokol/app as sapp
import sokol/glue as sglue
import math/vec3
import math/mat4
import shaders/cube as shd

var
  pip: Pipeline
  bindings: Bindings
  rx: float32 = 0
  ry: float32 = 0

const
  passAction = PassAction(
    colors: [
      ColorAttachmentAction(action: actionClear, value: (0.5, 0.5, 0.5, 1))
    ]
  )

proc init() {.cdecl.} =
  sg.setup(sg.Desc(context: sglue.context()))

  const vertices = [
    # position             color0
    -1.0'f32, -1.0, -1.0, 1.0, 0.0, 0.0, 1.0,
     1.0, -1.0, -1.0, 1.0, 0.0, 0.0, 1.0,
     1.0, 1.0, -1.0, 1.0, 0.0, 0.0, 1.0,
    -1.0, 1.0, -1.0, 1.0, 0.0, 0.0, 1.0,

    -1.0, -1.0, 1.0, 0.0, 1.0, 0.0, 1.0,
     1.0, -1.0, 1.0, 0.0, 1.0, 0.0, 1.0,
     1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0,
    -1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0,

    -1.0, -1.0, -1.0, 0.0, 0.0, 1.0, 1.0,
    -1.0, 1.0, -1.0, 0.0, 0.0, 1.0, 1.0,
    -1.0, 1.0, 1.0, 0.0, 0.0, 1.0, 1.0,
    -1.0, -1.0, 1.0, 0.0, 0.0, 1.0, 1.0,

     1.0, -1.0, -1.0, 1.0, 0.5, 0.0, 1.0,
     1.0, 1.0, -1.0, 1.0, 0.5, 0.0, 1.0,
     1.0, 1.0, 1.0, 1.0, 0.5, 0.0, 1.0,
     1.0, -1.0, 1.0, 1.0, 0.5, 0.0, 1.0,

    -1.0, -1.0, -1.0, 0.0, 0.5, 1.0, 1.0,
    -1.0, -1.0, 1.0, 0.0, 0.5, 1.0, 1.0,
     1.0, -1.0, 1.0, 0.0, 0.5, 1.0, 1.0,
     1.0, -1.0, -1.0, 0.0, 0.5, 1.0, 1.0,

    -1.0, 1.0, -1.0, 1.0, 0.0, 0.5, 1.0,
    -1.0, 1.0, 1.0, 1.0, 0.0, 0.5, 1.0,
     1.0, 1.0, 1.0, 1.0, 0.0, 0.5, 1.0,
     1.0, 1.0, -1.0, 1.0, 0.0, 0.5, 1.0,
  ]
  let vbuf = sg.makeBuffer(BufferDesc(
    data: sg.Range(addr: vertices.unsafeAddr, size: vertices.sizeof)
  ))

  const indices = [
    0'u16, 1, 2, 0, 2, 3,
    6, 5, 4, 7, 6, 4,
    8, 9, 10, 8, 10, 11,
    14, 13, 12, 15, 14, 12,
    16, 17, 18, 16, 18, 19,
    22, 21, 20, 23, 22, 20,
  ]
  let ibuf = sg.makeBuffer(BufferDesc(
    type: bufferTypeIndexBuffer,
    data: sg.Range(addr: indices.unsafeAddr, size: indices.sizeof)
  ))

  var backend = sg.queryBackend()
  var shader = shd.cubeShaderDesc(backend)
  pip = sg.makePipeline(PipelineDesc(
    shader: sg.makeShader(shader),
    layout: LayoutDesc(
      buffers: [
        BufferLayoutDesc(stride: 28),
      ],
      attrs: [
        VertexAttrDesc(bufferIndex: 0, offset: 0, format: vertexFormatFloat3),
        VertexAttrDesc(bufferIndex: 0, offset: 12, format: vertexFormatFloat4),
      ],
    ),
    indexType: indexTypeUint16,
    depth: DepthState(
      compare: compareFuncLessEqual,
      writeEnabled: true,
    ),
    primitiveType: primitiveTypePoints
  ))

  bindings = Bindings(vertexBuffers: [vbuf], indexBuffer: ibuf)

proc computeVsParams(): shd.VsParams =
  let proj = persp(60.0f, sapp.widthf()/sapp.heightf(), 0.01f, 10.0f)
  let view = lookat(vec3(0.0f, 1.5f, 6.0f), vec3.zero(), vec3.up())
  let rxm = rotate(rx, vec3(1f, 0f, 0f))
  let rym = rotate(ry, vec3(0f, 1f, 0f))
  let model = rxm * rym
  result = VsParams(mvp: proj * view * model)

proc frame() {.cdecl.} =
  let dt = sapp.frameDuration() * 60f
  rx += 1f * dt
  ry += 2f * dt

  let vsParams = computeVsParams()
  sg.beginDefaultPass(passAction, sapp.width(), sapp.height())
  sg.applyPipeline(pip)
  sg.applyBindings(bindings)
  sg.applyUniforms(shaderStageVs, shd.slotVsParams, sg.Range(
      addr: vsParams.unsafeAddr, size: vsParams.sizeof))
  sg.draw(0, 36, 1)
  sg.endPass()
  sg.commit()

proc cleanup() {.cdecl.} =
  sg.shutdown()

# type Event* = object
#   frameCount*:uint64
#   `type`*:EventType
#   keyCode*:Keycode
#   charCode*:uint32
#   keyRepeat*:bool
#   modifiers*:uint32
#   mouseButton*:Mousebutton
#   mouseX*:float32
#   mouseY*:float32
#   mouseDx*:float32
#   mouseDy*:float32
#   scrollX*:float32
#   scrollY*:float32
#   numTouches*:int32
#   touches*:array[8, Touchpoint]
#   windowWidth*:int32
#   windowHeight*:int32
#   framebufferWidth*:int32
#   framebufferHeight*:int32

proc event(e: ptr Event) {.cdecl.} =
  if e.keyCode == keyCodeEscape:
    sapp.quit()
  
  # if e.type == eventTypeMouseMove:
  #   echo e.mouseX, ' ',e.mouseY

  # if ev.type == eventTypeKeyDown:
  #     vsParams.draw_mode = case ev.keyCode:
  #         of keyCode1: 0f
  #         of keyCode2: 1f
  #         of keyCode3: 2f
  #         else: vsParams.draw_mode

sapp.run(sapp.Desc(
  initCb: init,
  frameCb: frame,
  eventCb: event,
  cleanupCb: cleanup,
  windowTitle: "cube.nim",
  width: 800,
  height: 800,
  sampleCount: 4,
  icon: IconDesc(sokol_default: true)
))
