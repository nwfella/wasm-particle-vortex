(module
 (type $0 (func (result i32)))
 (type $1 (func (result f32)))
 (type $2 (func (param i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (type $4 (func (param f32) (result f32)))
 (type $5 (func (param f32 f32 f32)))
 (type $6 (func))
 (type $7 (func (param i32 i32 i32 i32)))
 (type $8 (func (param f32 f32)))
 (type $9 (func (param f32 f32 f32 f32 f32)))
 (type $10 (func (param f32 f32 f32 f32 f32 f32)))
 (type $11 (func (param i32 f32 f32 f32 f32 f32 f32)))
 (type $12 (func (param i32 i32)))
 (import "env" "abort" (func $~lib/builtins/abort (param i32 i32 i32 i32)))
 (global $~lib/rt/stub/offset (mut i32) (i32.const 0))
 (global $src/vortex/bufPos (mut i32) (i32.const 0))
 (global $src/vortex/bufVel (mut i32) (i32.const 0))
 (global $src/vortex/bufPrp (mut i32) (i32.const 0))
 (global $src/vortex/bufDbg (mut i32) (i32.const 0))
 (global $src/vortex/bufIdx (mut i32) (i32.const 0))
 (global $src/vortex/bufSrt (mut i32) (i32.const 0))
 (global $src/vortex/bufCel (mut i32) (i32.const 0))
 (global $src/vortex/bufOff (mut i32) (i32.const 0))
 (global $src/vortex/bufCur (mut i32) (i32.const 0))
 (global $src/vortex/bufOcc (mut i32) (i32.const 0))
 (global $src/vortex/bufNoise (mut i32) (i32.const 0))
 (global $src/vortex/bufOut (mut i32) (i32.const 0))
 (global $src/vortex/P (mut i32) (i32.const 0))
 (global $src/vortex/V (mut i32) (i32.const 0))
 (global $src/vortex/R (mut i32) (i32.const 0))
 (global $src/vortex/D (mut i32) (i32.const 0))
 (global $src/vortex/IDX (mut i32) (i32.const 0))
 (global $src/vortex/SRT (mut i32) (i32.const 0))
 (global $src/vortex/CEL (mut i32) (i32.const 0))
 (global $src/vortex/OFF (mut i32) (i32.const 0))
 (global $src/vortex/CUR (mut i32) (i32.const 0))
 (global $src/vortex/OCC (mut i32) (i32.const 0))
 (global $src/vortex/NOISEP (mut i32) (i32.const 0))
 (global $src/vortex/OUT (mut i32) (i32.const 0))
 (global $src/vortex/NV (mut i32) (i32.const 0))
 (global $src/vortex/SEED (mut i32) (i32.const 1337))
 (global $src/vortex/RNG (mut i32) (i32.const 1337))
 (global $src/vortex/FRAME (mut i32) (i32.const 0))
 (global $src/vortex/NOISE_READY (mut i32) (i32.const 0))
 (global $src/vortex/ESCAPES (mut i32) (i32.const 0))
 (global $src/vortex/NOCC (mut i32) (i32.const 1))
 (global $src/vortex/TARGET_DEN (mut f32) (f32.const 1))
 (global $src/vortex/INV_DEN (mut f32) (f32.const 1))
 (global $src/vortex/DBG_ON (mut i32) (i32.const 0))
 (global $src/vortex/SPIN (mut f32) (f32.const 2.799999952316284))
 (global $src/vortex/POLO (mut f32) (f32.const 1.5))
 (global $src/vortex/TURB (mut f32) (f32.const 0.30000001192092896))
 (global $src/vortex/CONF (mut f32) (f32.const 8))
 (global $src/vortex/STEER (mut f32) (f32.const 10))
 (global $src/vortex/PRESS (mut f32) (f32.const 0.550000011920929))
 (global $src/vortex/MX (mut f32) (f32.const 0))
 (global $src/vortex/MY (mut f32) (f32.const 0))
 (global $src/vortex/MZ (mut f32) (f32.const 0))
 (global $src/vortex/MR (mut f32) (f32.const 0.5))
 (global $src/vortex/MS (mut f32) (f32.const 0))
 (global $src/vortex/GRID_INT (mut i32) (i32.const 3))
 (global $src/vortex/FX (mut f32) (f32.const 0))
 (global $src/vortex/FY (mut f32) (f32.const 0))
 (global $src/vortex/FZ (mut f32) (f32.const 0))
 (global $src/vortex/Q_RHO (mut f32) (f32.const 0))
 (global $src/vortex/Q_INVR (mut f32) (f32.const 0))
 (global $src/vortex/Q_U2 (mut f32) (f32.const 0))
 (global $~lib/math/rempio2f_y (mut f64) (f64.const 0))
 (memory $0 1)
 (data $0 (i32.const 1036) ",")
 (data $0.1 (i32.const 1048) "\02\00\00\00\1c\00\00\00I\00n\00v\00a\00l\00i\00d\00 \00l\00e\00n\00g\00t\00h")
 (data $1 (i32.const 1084) "<")
 (data $1.1 (i32.const 1096) "\02\00\00\00&\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
 (data $2 (i32.const 1148) "<")
 (data $2.1 (i32.const 1160) "\02\00\00\00(\00\00\00A\00l\00l\00o\00c\00a\00t\00i\00o\00n\00 \00t\00o\00o\00 \00l\00a\00r\00g\00e")
 (data $3 (i32.const 1212) "<")
 (data $3.1 (i32.const 1224) "\02\00\00\00\1e\00\00\00~\00l\00i\00b\00/\00r\00t\00/\00s\00t\00u\00b\00.\00t\00s")
 (data $4 (i32.const 1280) ")\15DNn\83\f9\a2\c0\dd4\f5\d1W\'\fcA\90C<\99\95b\dba\c5\bb\de\abcQ\fe")
 (data $5 (i32.const 1324) "<")
 (data $5.1 (i32.const 1336) "\02\00\00\00$\00\00\00I\00n\00d\00e\00x\00 \00o\00u\00t\00 \00o\00f\00 \00r\00a\00n\00g\00e")
 (data $6 (i32.const 1388) "<")
 (data $6.1 (i32.const 1400) "\02\00\00\00$\00\00\00~\00l\00i\00b\00/\00t\00y\00p\00e\00d\00a\00r\00r\00a\00y\00.\00t\00s")
 (export "init" (func $src/vortex/init))
 (export "reset" (func $src/vortex/reset))
 (export "step" (func $src/vortex/step))
 (export "setFlow" (func $src/vortex/setFlow))
 (export "setMouse" (func $src/vortex/setMouse))
 (export "setDebug" (func $src/vortex/setDebug))
 (export "setGridInterval" (func $src/vortex/setGridInterval))
 (export "posPtr" (func $src/vortex/posPtr))
 (export "velPtr" (func $src/vortex/velPtr))
 (export "prpPtr" (func $src/vortex/prpPtr))
 (export "dbgPtr" (func $src/vortex/dbgPtr))
 (export "sortedPtr" (func $src/vortex/sortedPtr))
 (export "cellPtr" (func $src/vortex/cellPtr))
 (export "getCount" (func $src/vortex/getCount))
 (export "getMaxParticles" (func $src/vortex/getMaxParticles))
 (export "getGridDim" (func $src/vortex/getGridDim))
 (export "getGridCells" (func $src/vortex/getGridCells))
 (export "getOccupancy" (func $src/vortex/getOccupancy))
 (export "getTargetDensity" (func $src/vortex/getTargetDensity))
 (export "getGridInterval" (func $src/vortex/getGridInterval))
 (export "getFrame" (func $src/vortex/getFrame))
 (export "getEscapes" (func $src/vortex/getEscapes))
 (export "nanCount" (func $src/vortex/nanCount))
 (export "maxAbsCoord" (func $src/vortex/maxAbsCoord))
 (export "meanSpeed2" (func $src/vortex/meanSpeed2))
 (export "meanTubeRadius" (func $src/vortex/meanTubeRadius))
 (export "escapeFraction" (func $src/vortex/escapeFraction))
 (export "verifyGrid" (func $src/vortex/verifyGrid))
 (export "flowSample" (func $src/vortex/flowSample))
 (export "flowOut" (func $src/vortex/flowOut))
 (export "poke" (func $src/vortex/poke))
 (export "memory" (memory $0))
 (start $~start)
 (func $~lib/rt/stub/__new (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  local.get $0
  i32.const 1073741804
  i32.gt_u
  if
   i32.const 1168
   i32.const 1232
   i32.const 86
   i32.const 30
   call $~lib/builtins/abort
   unreachable
  end
  local.get $0
  i32.const 16
  i32.add
  local.tee $3
  i32.const 1073741820
  i32.gt_u
  if
   i32.const 1168
   i32.const 1232
   i32.const 33
   i32.const 29
   call $~lib/builtins/abort
   unreachable
  end
  global.get $~lib/rt/stub/offset
  i32.const 4
  i32.add
  local.tee $2
  local.get $3
  i32.const 19
  i32.add
  i32.const -16
  i32.and
  i32.const 4
  i32.sub
  local.tee $3
  i32.add
  local.tee $4
  memory.size
  local.tee $5
  i32.const 16
  i32.shl
  i32.const 15
  i32.add
  i32.const -16
  i32.and
  local.tee $6
  i32.gt_u
  if
   local.get $5
   local.get $4
   local.get $6
   i32.sub
   i32.const 65535
   i32.add
   i32.const -65536
   i32.and
   i32.const 16
   i32.shr_u
   local.tee $6
   local.get $5
   local.get $6
   i32.gt_s
   select
   memory.grow
   i32.const 0
   i32.lt_s
   if
    local.get $6
    memory.grow
    i32.const 0
    i32.lt_s
    if
     unreachable
    end
   end
  end
  global.get $~lib/rt/stub/offset
  local.get $4
  global.set $~lib/rt/stub/offset
  local.get $3
  i32.store
  local.get $2
  i32.const 4
  i32.sub
  local.tee $3
  i32.const 0
  i32.store offset=4
  local.get $3
  i32.const 0
  i32.store offset=8
  local.get $3
  local.get $1
  i32.store offset=12
  local.get $3
  local.get $0
  i32.store offset=16
  local.get $2
  i32.const 16
  i32.add
 )
 (func $~lib/arraybuffer/ArrayBufferView#constructor (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  local.get $0
  i32.eqz
  if
   i32.const 12
   i32.const 3
   call $~lib/rt/stub/__new
   local.set $0
  end
  local.get $0
  i32.const 0
  i32.store
  local.get $0
  i32.const 0
  i32.store offset=4
  local.get $0
  i32.const 0
  i32.store offset=8
  local.get $1
  i32.const 268435455
  i32.gt_u
  if
   i32.const 1056
   i32.const 1104
   i32.const 19
   i32.const 57
   call $~lib/builtins/abort
   unreachable
  end
  local.get $1
  i32.const 2
  i32.shl
  local.tee $1
  i32.const 1
  call $~lib/rt/stub/__new
  local.tee $2
  i32.const 0
  local.get $1
  memory.fill
  local.get $0
  local.get $2
  i32.store
  local.get $0
  local.get $2
  i32.store offset=4
  local.get $0
  local.get $1
  i32.store offset=8
  local.get $0
 )
 (func $~lib/math/NativeMathf.sin (param $0 f32) (result f32)
  (local $1 f64)
  (local $2 f64)
  (local $3 i32)
  (local $4 f64)
  (local $5 i64)
  (local $6 i32)
  (local $7 i32)
  (local $8 i64)
  (local $9 i64)
  local.get $0
  i32.reinterpret_f32
  local.tee $3
  i32.const 31
  i32.shr_u
  local.set $6
  block $folding-inner0
   local.get $3
   i32.const 2147483647
   i32.and
   local.tee $3
   i32.const 1061752794
   i32.le_u
   if
    local.get $3
    i32.const 964689920
    i32.lt_u
    if
     local.get $0
     return
    end
    local.get $0
    f64.promote_f32
    local.tee $2
    local.get $2
    f64.mul
    local.tee $1
    local.get $2
    f64.mul
    local.set $4
    br $folding-inner0
   end
   local.get $3
   i32.const 1081824209
   i32.le_u
   if
    local.get $3
    i32.const 1075235811
    i32.le_u
    if
     local.get $6
     if (result f32)
      local.get $0
      f64.promote_f32
      f64.const 1.5707963267948966
      f64.add
      local.tee $1
      local.get $1
      f64.mul
      local.tee $1
      local.get $1
      f64.mul
      local.set $2
      local.get $1
      f64.const -0.499999997251031
      f64.mul
      f64.const 1
      f64.add
      local.get $2
      f64.const 0.04166662332373906
      f64.mul
      f64.add
      local.get $2
      local.get $1
      f64.mul
      local.get $1
      f64.const 2.439044879627741e-05
      f64.mul
      f64.const -0.001388676377460993
      f64.add
      f64.mul
      f64.add
      f32.demote_f64
      f32.neg
     else
      local.get $0
      f64.promote_f32
      f64.const -1.5707963267948966
      f64.add
      local.tee $1
      local.get $1
      f64.mul
      local.tee $1
      local.get $1
      f64.mul
      local.set $2
      local.get $1
      f64.const -0.499999997251031
      f64.mul
      f64.const 1
      f64.add
      local.get $2
      f64.const 0.04166662332373906
      f64.mul
      f64.add
      local.get $2
      local.get $1
      f64.mul
      local.get $1
      f64.const 2.439044879627741e-05
      f64.mul
      f64.const -0.001388676377460993
      f64.add
      f64.mul
      f64.add
      f32.demote_f64
     end
     return
    end
    local.get $0
    f64.promote_f32
    local.tee $1
    f64.const 3.141592653589793
    f64.add
    local.get $1
    f64.const -3.141592653589793
    f64.add
    local.get $6
    select
    f64.neg
    local.tee $2
    local.get $2
    f64.mul
    local.tee $1
    local.get $2
    f64.mul
    local.set $4
    br $folding-inner0
   end
   local.get $3
   i32.const 1088565717
   i32.le_u
   if
    local.get $3
    i32.const 1085271519
    i32.le_u
    if
     local.get $6
     if (result f32)
      local.get $0
      f64.promote_f32
      f64.const 4.71238898038469
      f64.add
      local.tee $1
      local.get $1
      f64.mul
      local.tee $1
      local.get $1
      f64.mul
      local.set $2
      local.get $1
      f64.const -0.499999997251031
      f64.mul
      f64.const 1
      f64.add
      local.get $2
      f64.const 0.04166662332373906
      f64.mul
      f64.add
      local.get $2
      local.get $1
      f64.mul
      local.get $1
      f64.const 2.439044879627741e-05
      f64.mul
      f64.const -0.001388676377460993
      f64.add
      f64.mul
      f64.add
      f32.demote_f64
     else
      local.get $0
      f64.promote_f32
      f64.const -4.71238898038469
      f64.add
      local.tee $1
      local.get $1
      f64.mul
      local.tee $1
      local.get $1
      f64.mul
      local.set $2
      local.get $1
      f64.const -0.499999997251031
      f64.mul
      f64.const 1
      f64.add
      local.get $2
      f64.const 0.04166662332373906
      f64.mul
      f64.add
      local.get $2
      local.get $1
      f64.mul
      local.get $1
      f64.const 2.439044879627741e-05
      f64.mul
      f64.const -0.001388676377460993
      f64.add
      f64.mul
      f64.add
      f32.demote_f64
      f32.neg
     end
     return
    end
    local.get $0
    f64.promote_f32
    local.tee $1
    f64.const 6.283185307179586
    f64.add
    local.get $1
    f64.const -6.283185307179586
    f64.add
    local.get $6
    select
    local.tee $2
    local.get $2
    f64.mul
    local.tee $1
    local.get $2
    f64.mul
    local.set $4
    br $folding-inner0
   end
   local.get $3
   i32.const 2139095040
   i32.ge_u
   if
    local.get $0
    local.get $0
    f32.sub
    return
   end
   block $~lib/math/rempio2f|inlined.1 (result i32)
    local.get $3
    i32.const 1305022427
    i32.lt_u
    if
     local.get $0
     f64.promote_f32
     local.tee $1
     f64.const 0.6366197723675814
     f64.mul
     f64.nearest
     local.set $2
     local.get $1
     local.get $2
     f64.const 1.5707963109016418
     f64.mul
     f64.sub
     local.get $2
     f64.const 1.5893254773528196e-08
     f64.mul
     f64.sub
     global.set $~lib/math/rempio2f_y
     local.get $2
     i32.trunc_sat_f64_s
     br $~lib/math/rempio2f|inlined.1
    end
    local.get $3
    i32.const 23
    i32.shr_s
    i32.const 152
    i32.sub
    local.tee $7
    i32.const 63
    i32.and
    i64.extend_i32_s
    local.set $8
    local.get $7
    i32.const 6
    i32.shr_s
    i32.const 3
    i32.shl
    i32.const 1280
    i32.add
    local.tee $7
    i64.load offset=8
    local.set $5
    f64.const 8.515303950216386e-20
    local.get $0
    f64.promote_f32
    f64.copysign
    local.get $3
    i32.const 8388607
    i32.and
    i32.const 8388608
    i32.or
    i64.extend_i32_s
    local.tee $9
    local.get $7
    i64.load
    local.get $8
    i64.shl
    local.get $5
    i64.const 64
    local.get $8
    i64.sub
    i64.shr_u
    i64.or
    i64.mul
    local.get $8
    i64.const 32
    i64.gt_u
    if (result i64)
     local.get $5
     local.get $8
     i64.const 32
     i64.sub
     i64.shl
     local.get $7
     i64.load offset=16
     i64.const 96
     local.get $8
     i64.sub
     i64.shr_u
     i64.or
    else
     local.get $5
     i64.const 32
     local.get $8
     i64.sub
     i64.shr_u
    end
    local.get $9
    i64.mul
    i64.const 32
    i64.shr_u
    i64.add
    local.tee $5
    i64.const 2
    i64.shl
    local.tee $8
    f64.convert_i64_s
    f64.mul
    global.set $~lib/math/rempio2f_y
    i32.const 0
    local.get $5
    i64.const 62
    i64.shr_u
    local.get $8
    i64.const 63
    i64.shr_u
    i64.add
    i32.wrap_i64
    local.tee $3
    i32.sub
    local.get $3
    local.get $6
    select
   end
   local.set $3
   global.get $~lib/math/rempio2f_y
   local.set $1
   local.get $3
   i32.const 1
   i32.and
   if (result f32)
    local.get $1
    local.get $1
    f64.mul
    local.tee $1
    local.get $1
    f64.mul
    local.set $2
    local.get $1
    f64.const -0.499999997251031
    f64.mul
    f64.const 1
    f64.add
    local.get $2
    f64.const 0.04166662332373906
    f64.mul
    f64.add
    local.get $2
    local.get $1
    f64.mul
    local.get $1
    f64.const 2.439044879627741e-05
    f64.mul
    f64.const -0.001388676377460993
    f64.add
    f64.mul
    f64.add
    f32.demote_f64
   else
    local.get $1
    local.get $1
    local.get $1
    f64.mul
    local.tee $2
    local.get $1
    f64.mul
    local.tee $1
    local.get $2
    f64.const 0.008333329385889463
    f64.mul
    f64.const -0.16666666641626524
    f64.add
    f64.mul
    f64.add
    local.get $1
    local.get $2
    local.get $2
    f64.mul
    f64.mul
    local.get $2
    f64.const 2.718311493989822e-06
    f64.mul
    f64.const -1.9839334836096632e-04
    f64.add
    f64.mul
    f64.add
    f32.demote_f64
   end
   local.tee $0
   f32.neg
   local.get $0
   local.get $3
   i32.const 2
   i32.and
   select
   return
  end
  local.get $2
  local.get $4
  local.get $1
  f64.const 0.008333329385889463
  f64.mul
  f64.const -0.16666666641626524
  f64.add
  f64.mul
  f64.add
  local.get $4
  local.get $1
  local.get $1
  f64.mul
  f64.mul
  local.get $1
  f64.const 2.718311493989822e-06
  f64.mul
  f64.const -1.9839334836096632e-04
  f64.add
  f64.mul
  f64.add
  f32.demote_f64
 )
 (func $~lib/math/NativeMathf.cos (param $0 f32) (result f32)
  (local $1 f64)
  (local $2 f64)
  (local $3 i32)
  (local $4 i64)
  (local $5 i32)
  (local $6 f64)
  (local $7 i32)
  (local $8 i64)
  (local $9 i64)
  local.get $0
  i32.reinterpret_f32
  local.tee $3
  i32.const 31
  i32.shr_u
  local.set $5
  block $folding-inner0
   local.get $3
   i32.const 2147483647
   i32.and
   local.tee $3
   i32.const 1061752794
   i32.le_u
   if
    local.get $3
    i32.const 964689920
    i32.lt_u
    if
     f32.const 1
     return
    end
    local.get $0
    f64.promote_f32
    local.tee $1
    local.get $1
    f64.mul
    local.tee $1
    local.get $1
    f64.mul
    local.set $2
    br $folding-inner0
   end
   local.get $3
   i32.const 1081824209
   i32.le_u
   if
    local.get $3
    i32.const 1075235811
    i32.gt_u
    if
     local.get $0
     f64.promote_f32
     local.tee $1
     f64.const 3.141592653589793
     f64.add
     local.get $1
     f64.const -3.141592653589793
     f64.add
     local.get $5
     select
     local.tee $1
     local.get $1
     f64.mul
     local.tee $1
     local.get $1
     f64.mul
     local.set $2
     local.get $1
     f64.const -0.499999997251031
     f64.mul
     f64.const 1
     f64.add
     local.get $2
     f64.const 0.04166662332373906
     f64.mul
     f64.add
     local.get $2
     local.get $1
     f64.mul
     local.get $1
     f64.const 2.439044879627741e-05
     f64.mul
     f64.const -0.001388676377460993
     f64.add
     f64.mul
     f64.add
     f32.demote_f64
     f32.neg
     return
    else
     local.get $5
     if (result f64)
      local.get $0
      f64.promote_f32
      f64.const 1.5707963267948966
      f64.add
      local.tee $2
      local.get $2
      f64.mul
      local.tee $1
      local.get $2
      f64.mul
     else
      f64.const 1.5707963267948966
      local.get $0
      f64.promote_f32
      f64.sub
      local.tee $2
      local.get $2
      f64.mul
      local.tee $1
      local.get $2
      f64.mul
     end
     local.set $6
     local.get $2
     local.get $6
     local.get $1
     f64.const 0.008333329385889463
     f64.mul
     f64.const -0.16666666641626524
     f64.add
     f64.mul
     f64.add
     local.get $6
     local.get $1
     local.get $1
     f64.mul
     f64.mul
     local.get $1
     f64.const 2.718311493989822e-06
     f64.mul
     f64.const -1.9839334836096632e-04
     f64.add
     f64.mul
     f64.add
     f32.demote_f64
     return
    end
    unreachable
   end
   local.get $3
   i32.const 1088565717
   i32.le_u
   if
    local.get $3
    i32.const 1085271519
    i32.gt_u
    if
     local.get $0
     f64.promote_f32
     local.tee $1
     f64.const 6.283185307179586
     f64.add
     local.get $1
     f64.const -6.283185307179586
     f64.add
     local.get $5
     select
     local.tee $1
     local.get $1
     f64.mul
     local.tee $1
     local.get $1
     f64.mul
     local.set $2
     br $folding-inner0
    else
     local.get $5
     if (result f64)
      local.get $0
      f32.neg
      f64.promote_f32
      f64.const -4.71238898038469
      f64.add
      local.tee $2
      local.get $2
      f64.mul
      local.tee $1
      local.get $2
      f64.mul
     else
      local.get $0
      f64.promote_f32
      f64.const -4.71238898038469
      f64.add
      local.tee $2
      local.get $2
      f64.mul
      local.tee $1
      local.get $2
      f64.mul
     end
     local.set $6
     local.get $2
     local.get $6
     local.get $1
     f64.const 0.008333329385889463
     f64.mul
     f64.const -0.16666666641626524
     f64.add
     f64.mul
     f64.add
     local.get $6
     local.get $1
     local.get $1
     f64.mul
     f64.mul
     local.get $1
     f64.const 2.718311493989822e-06
     f64.mul
     f64.const -1.9839334836096632e-04
     f64.add
     f64.mul
     f64.add
     f32.demote_f64
     return
    end
    unreachable
   end
   local.get $3
   i32.const 2139095040
   i32.ge_u
   if
    local.get $0
    local.get $0
    f32.sub
    return
   end
   block $~lib/math/rempio2f|inlined.0 (result i32)
    local.get $3
    i32.const 1305022427
    i32.lt_u
    if
     local.get $0
     f64.promote_f32
     local.tee $1
     f64.const 0.6366197723675814
     f64.mul
     f64.nearest
     local.set $2
     local.get $1
     local.get $2
     f64.const 1.5707963109016418
     f64.mul
     f64.sub
     local.get $2
     f64.const 1.5893254773528196e-08
     f64.mul
     f64.sub
     global.set $~lib/math/rempio2f_y
     local.get $2
     i32.trunc_sat_f64_s
     br $~lib/math/rempio2f|inlined.0
    end
    local.get $3
    i32.const 23
    i32.shr_s
    i32.const 152
    i32.sub
    local.tee $7
    i32.const 63
    i32.and
    i64.extend_i32_s
    local.set $8
    local.get $7
    i32.const 6
    i32.shr_s
    i32.const 3
    i32.shl
    i32.const 1280
    i32.add
    local.tee $7
    i64.load offset=8
    local.set $4
    f64.const 8.515303950216386e-20
    local.get $0
    f64.promote_f32
    f64.copysign
    local.get $3
    i32.const 8388607
    i32.and
    i32.const 8388608
    i32.or
    i64.extend_i32_s
    local.tee $9
    local.get $7
    i64.load
    local.get $8
    i64.shl
    local.get $4
    i64.const 64
    local.get $8
    i64.sub
    i64.shr_u
    i64.or
    i64.mul
    local.get $8
    i64.const 32
    i64.gt_u
    if (result i64)
     local.get $4
     local.get $8
     i64.const 32
     i64.sub
     i64.shl
     local.get $7
     i64.load offset=16
     i64.const 96
     local.get $8
     i64.sub
     i64.shr_u
     i64.or
    else
     local.get $4
     i64.const 32
     local.get $8
     i64.sub
     i64.shr_u
    end
    local.get $9
    i64.mul
    i64.const 32
    i64.shr_u
    i64.add
    local.tee $4
    i64.const 2
    i64.shl
    local.tee $8
    f64.convert_i64_s
    f64.mul
    global.set $~lib/math/rempio2f_y
    i32.const 0
    local.get $4
    i64.const 62
    i64.shr_u
    local.get $8
    i64.const 63
    i64.shr_u
    i64.add
    i32.wrap_i64
    local.tee $3
    i32.sub
    local.get $3
    local.get $5
    select
   end
   local.set $3
   global.get $~lib/math/rempio2f_y
   local.set $1
   local.get $3
   i32.const 1
   i32.and
   if (result f32)
    local.get $1
    local.get $1
    local.get $1
    f64.mul
    local.tee $2
    local.get $1
    f64.mul
    local.tee $1
    local.get $2
    f64.const 0.008333329385889463
    f64.mul
    f64.const -0.16666666641626524
    f64.add
    f64.mul
    f64.add
    local.get $1
    local.get $2
    local.get $2
    f64.mul
    f64.mul
    local.get $2
    f64.const 2.718311493989822e-06
    f64.mul
    f64.const -1.9839334836096632e-04
    f64.add
    f64.mul
    f64.add
    f32.demote_f64
   else
    local.get $1
    local.get $1
    f64.mul
    local.tee $1
    local.get $1
    f64.mul
    local.set $2
    local.get $1
    f64.const -0.499999997251031
    f64.mul
    f64.const 1
    f64.add
    local.get $2
    f64.const 0.04166662332373906
    f64.mul
    f64.add
    local.get $2
    local.get $1
    f64.mul
    local.get $1
    f64.const 2.439044879627741e-05
    f64.mul
    f64.const -0.001388676377460993
    f64.add
    f64.mul
    f64.add
    f32.demote_f64
   end
   local.tee $0
   f32.neg
   local.get $0
   local.get $3
   i32.const 1
   i32.add
   i32.const 2
   i32.and
   select
   return
  end
  local.get $1
  f64.const -0.499999997251031
  f64.mul
  f64.const 1
  f64.add
  local.get $2
  f64.const 0.04166662332373906
  f64.mul
  f64.add
  local.get $2
  local.get $1
  f64.mul
  local.get $1
  f64.const 2.439044879627741e-05
  f64.mul
  f64.const -0.001388676377460993
  f64.add
  f64.mul
  f64.add
  f32.demote_f64
 )
 (func $src/vortex/buildGrid (param $0 f32) (param $1 f32) (param $2 f32)
  (local $3 i32)
  (local $4 f32)
  (local $5 i32)
  (local $6 f32)
  (local $7 i32)
  (local $8 f32)
  (local $9 f32)
  (local $10 f32)
  (local $11 f32)
  (local $12 f32)
  (local $13 f32)
  (local $14 i32)
  (local $15 i32)
  (local $16 i32)
  (local $17 i32)
  (local $18 i32)
  global.get $src/vortex/NOISE_READY
  i32.eqz
  if
   loop $for-loop|0
    local.get $3
    i32.const 1024
    i32.lt_s
    if
     local.get $3
     f32.convert_i32_s
     f32.const 2.399962902069092
     f32.mul
     call $~lib/math/NativeMathf.sin
     f32.const 43758.546875
     f32.mul
     local.tee $4
     local.get $4
     i32.trunc_sat_f32_s
     f32.convert_i32_s
     f32.sub
     f32.const 2
     f32.mul
     f32.const -1
     f32.add
     local.set $4
     local.get $3
     global.get $src/vortex/bufNoise
     local.tee $14
     i32.load offset=8
     i32.const 2
     i32.shr_u
     i32.ge_u
     if
      i32.const 1344
      i32.const 1408
      i32.const 1315
      i32.const 64
      call $~lib/builtins/abort
      unreachable
     end
     local.get $14
     i32.load offset=4
     local.get $3
     i32.const 2
     i32.shl
     i32.add
     local.get $4
     f32.store
     local.get $3
     i32.const 1
     i32.add
     local.set $3
     br $for-loop|0
    end
   end
   global.get $src/vortex/bufNoise
   i32.load offset=4
   global.set $src/vortex/NOISEP
   i32.const 1
   global.set $src/vortex/NOISE_READY
  end
  i32.const 0
  local.set $3
  loop $for-loop|00
   local.get $3
   i32.const 32768
   i32.lt_s
   if
    global.get $src/vortex/CUR
    local.get $3
    i32.const 2
    i32.shl
    i32.add
    i32.const 0
    i32.store
    global.get $src/vortex/CEL
    local.get $3
    i32.const 4
    i32.shl
    i32.add
    f32.const 0
    f32.store offset=12
    local.get $3
    i32.const 1
    i32.add
    local.set $3
    br $for-loop|00
   end
  end
  i32.const 0
  local.set $3
  loop $for-loop|1
   local.get $5
   global.get $src/vortex/NV
   i32.lt_s
   if
    global.get $src/vortex/IDX
    local.get $5
    i32.const 2
    i32.shl
    i32.add
    i32.load
    local.tee $14
    i32.const 4
    i32.shl
    local.tee $15
    global.get $src/vortex/CEL
    i32.add
    f32.load offset=12
    f32.const 1
    f32.add
    local.set $4
    global.get $src/vortex/CEL
    local.get $15
    i32.add
    local.get $4
    f32.store offset=12
    local.get $4
    f32.const 1
    f32.eq
    if
     global.get $src/vortex/OCC
     local.get $3
     i32.const 2
     i32.shl
     i32.add
     local.get $14
     i32.store
     local.get $3
     i32.const 1
     i32.add
     local.set $3
    end
    local.get $5
    i32.const 1
    i32.add
    local.set $5
    br $for-loop|1
   end
  end
  i32.const 1
  local.get $3
  local.get $3
  i32.const 0
  i32.le_s
  select
  global.set $src/vortex/NOCC
  global.get $src/vortex/NV
  f32.convert_i32_s
  global.get $src/vortex/NOCC
  f32.convert_i32_s
  f32.div
  global.set $src/vortex/TARGET_DEN
  f32.const 1
  global.get $src/vortex/TARGET_DEN
  f32.div
  global.set $src/vortex/INV_DEN
  i32.const 0
  local.set $5
  i32.const 0
  local.set $3
  loop $for-loop|2
   local.get $3
   i32.const 32768
   i32.lt_s
   if
    local.get $3
    i32.const 2
    i32.shl
    local.tee $14
    global.get $src/vortex/OFF
    i32.add
    local.get $5
    i32.store
    global.get $src/vortex/CUR
    local.get $14
    i32.add
    local.get $5
    i32.store
    local.get $5
    global.get $src/vortex/CEL
    local.get $3
    i32.const 4
    i32.shl
    i32.add
    f32.load offset=12
    i32.trunc_sat_f32_s
    i32.add
    local.set $5
    local.get $3
    i32.const 1
    i32.add
    local.set $3
    br $for-loop|2
   end
  end
  global.get $src/vortex/OFF
  i32.const 131072
  i32.add
  local.get $5
  i32.store
  i32.const 0
  local.set $3
  loop $for-loop|3
   local.get $3
   global.get $src/vortex/NV
   i32.lt_s
   if
    global.get $src/vortex/SRT
    global.get $src/vortex/CUR
    global.get $src/vortex/IDX
    local.get $3
    i32.const 2
    i32.shl
    i32.add
    i32.load
    i32.const 2
    i32.shl
    i32.add
    local.tee $5
    i32.load
    local.tee $14
    i32.const 2
    i32.shl
    i32.add
    local.get $3
    i32.store
    local.get $5
    local.get $14
    i32.const 1
    i32.add
    i32.store
    local.get $3
    i32.const 1
    i32.add
    local.set $3
    br $for-loop|3
   end
  end
  i32.const 0
  local.set $3
  loop $for-loop|4
   local.get $3
   i32.const 32768
   i32.lt_s
   if
    global.get $src/vortex/CUR
    local.get $3
    i32.const 2
    i32.shl
    i32.add
    i32.const 0
    i32.store
    local.get $3
    i32.const 1
    i32.add
    local.set $3
    br $for-loop|4
   end
  end
  f32.const 1
  global.get $src/vortex/TARGET_DEN
  f32.const 1
  f32.add
  f32.div
  local.set $12
  loop $for-loop|5
   local.get $7
   global.get $src/vortex/NOCC
   i32.lt_s
   if
    global.get $src/vortex/OCC
    local.get $7
    i32.const 2
    i32.shl
    i32.add
    i32.load
    local.tee $5
    i32.const 4
    i32.shl
    local.tee $15
    global.get $src/vortex/CEL
    i32.add
    f32.load offset=12
    global.get $src/vortex/TARGET_DEN
    f32.sub
    local.set $4
    f32.const 0
    local.set $6
    f32.const 0
    local.set $8
    local.get $5
    i32.const 32
    i32.rem_s
    local.set $16
    local.get $5
    i32.const 32
    i32.div_s
    i32.const 32
    i32.rem_s
    local.set $3
    local.get $5
    i32.const 1024
    i32.div_s
    local.set $5
    local.get $4
    f32.const 0
    f32.gt
    if (result f32)
     global.get $src/vortex/CEL
     local.get $3
     i32.const 5
     i32.shl
     local.tee $14
     local.get $5
     i32.const 10
     i32.shl
     local.tee $17
     i32.add
     local.tee $18
     i32.const 31
     local.get $16
     i32.const 1
     i32.add
     local.get $16
     i32.const 31
     i32.ge_s
     select
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     global.get $src/vortex/CEL
     local.get $16
     i32.const 1
     i32.sub
     i32.const 0
     local.get $16
     i32.const 0
     i32.gt_s
     select
     local.get $18
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     f32.sub
     local.tee $9
     local.get $9
     f32.mul
     global.get $src/vortex/CEL
     local.get $17
     i32.const 31
     local.get $3
     i32.const 1
     i32.add
     local.get $3
     i32.const 31
     i32.ge_s
     select
     i32.const 5
     i32.shl
     i32.add
     local.get $16
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     global.get $src/vortex/CEL
     local.get $17
     local.get $3
     i32.const 1
     i32.sub
     i32.const 0
     local.get $3
     i32.const 0
     i32.gt_s
     select
     i32.const 5
     i32.shl
     i32.add
     local.get $16
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     f32.sub
     local.tee $10
     local.get $10
     f32.mul
     f32.add
     global.get $src/vortex/CEL
     i32.const 31
     local.get $5
     i32.const 1
     i32.add
     local.get $5
     i32.const 31
     i32.ge_s
     select
     i32.const 10
     i32.shl
     local.get $14
     i32.add
     local.get $16
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     global.get $src/vortex/CEL
     local.get $5
     i32.const 1
     i32.sub
     i32.const 0
     local.get $5
     i32.const 0
     i32.gt_s
     select
     i32.const 10
     i32.shl
     local.get $14
     i32.add
     local.get $16
     i32.add
     i32.const 4
     i32.shl
     i32.add
     f32.load offset=12
     f32.sub
     local.tee $11
     local.get $11
     f32.mul
     f32.add
     f32.sqrt
     local.tee $13
     f32.const 1.0000000474974513e-03
     f32.gt
     if (result f32)
      local.get $9
      f32.neg
      local.get $1
      local.get $4
      f32.mul
      local.get $12
      f32.mul
      local.get $13
      f32.div
      local.tee $4
      f32.mul
      local.set $6
      local.get $10
      f32.neg
      local.get $4
      f32.mul
      local.set $8
      local.get $11
      f32.neg
      local.get $4
      f32.mul
     else
      f32.const 0
     end
    else
     f32.const 0
    end
    local.set $4
    local.get $2
    f32.const 0
    f32.ne
    if
     local.get $6
     global.get $src/vortex/NOISEP
     local.get $5
     f32.convert_i32_s
     f32.const 0.699999988079071
     f32.mul
     local.get $0
     f32.const 1.7000000476837158
     f32.mul
     f32.add
     i32.trunc_sat_f32_s
     local.tee $5
     i32.const 83492791
     i32.mul
     local.get $16
     i32.const 73856093
     i32.mul
     local.get $3
     i32.const 19349663
     i32.mul
     i32.xor
     i32.xor
     local.tee $14
     local.get $14
     i32.const 13
     i32.shr_s
     i32.xor
     i32.const 1023
     i32.and
     i32.const 2
     i32.shl
     i32.add
     f32.load
     local.get $2
     f32.mul
     f32.add
     local.set $6
     local.get $8
     global.get $src/vortex/NOISEP
     local.get $16
     i32.const 7
     i32.add
     i32.const 83492791
     i32.mul
     local.get $3
     i32.const 73856093
     i32.mul
     local.get $5
     i32.const 19349663
     i32.mul
     i32.xor
     i32.xor
     local.tee $14
     local.get $14
     i32.const 13
     i32.shr_s
     i32.xor
     i32.const 1023
     i32.and
     i32.const 2
     i32.shl
     i32.add
     f32.load
     local.get $2
     f32.mul
     f32.add
     local.set $8
     local.get $4
     global.get $src/vortex/NOISEP
     local.get $3
     i32.const 13
     i32.add
     i32.const 83492791
     i32.mul
     local.get $5
     i32.const 73856093
     i32.mul
     local.get $16
     i32.const 19349663
     i32.mul
     i32.xor
     i32.xor
     local.tee $3
     local.get $3
     i32.const 13
     i32.shr_s
     i32.xor
     i32.const 1023
     i32.and
     i32.const 2
     i32.shl
     i32.add
     f32.load
     local.get $2
     f32.mul
     f32.add
     local.set $4
    end
    global.get $src/vortex/CEL
    local.get $15
    i32.add
    local.tee $3
    local.get $6
    f32.store
    local.get $3
    local.get $8
    f32.store offset=4
    local.get $3
    local.get $4
    f32.store offset=8
    local.get $7
    i32.const 1
    i32.add
    local.set $7
    br $for-loop|5
   end
  end
 )
 (func $src/vortex/spawn (param $0 i32)
  (local $1 f32)
  (local $2 f32)
  (local $3 f32)
  (local $4 f32)
  (local $5 f32)
  (local $6 i32)
  (local $7 i32)
  global.get $src/vortex/RNG
  i32.const 1664525
  i32.mul
  i32.const 1013904223
  i32.add
  global.set $src/vortex/RNG
  global.get $src/vortex/RNG
  i32.const 8
  i32.shr_u
  f32.convert_i32_u
  f32.const 5.9604644775390625e-08
  f32.mul
  f32.const 6.2831854820251465
  f32.mul
  local.set $2
  global.get $src/vortex/RNG
  i32.const 1664525
  i32.mul
  i32.const 1013904223
  i32.add
  global.set $src/vortex/RNG
  global.get $src/vortex/RNG
  i32.const 8
  i32.shr_u
  f32.convert_i32_u
  f32.const 5.9604644775390625e-08
  f32.mul
  f32.sqrt
  f32.const 0.4399999976158142
  f32.mul
  global.get $src/vortex/RNG
  i32.const 1664525
  i32.mul
  i32.const 1013904223
  i32.add
  global.set $src/vortex/RNG
  global.get $src/vortex/RNG
  i32.const 8
  i32.shr_u
  f32.convert_i32_u
  f32.const 5.9604644775390625e-08
  f32.mul
  f32.mul
  local.set $3
  global.get $src/vortex/RNG
  i32.const 1664525
  i32.mul
  i32.const 1013904223
  i32.add
  global.set $src/vortex/RNG
  local.get $3
  global.get $src/vortex/RNG
  i32.const 8
  i32.shr_u
  f32.convert_i32_u
  f32.const 5.9604644775390625e-08
  f32.mul
  f32.const 6.2831854820251465
  f32.mul
  local.tee $1
  call $~lib/math/NativeMathf.cos
  f32.mul
  f32.const 1
  f32.add
  local.tee $4
  local.get $2
  call $~lib/math/NativeMathf.cos
  f32.mul
  local.set $5
  local.get $3
  local.get $1
  call $~lib/math/NativeMathf.sin
  f32.mul
  local.set $1
  local.get $4
  local.get $2
  call $~lib/math/NativeMathf.sin
  f32.mul
  local.set $2
  local.get $0
  i32.const 4
  i32.shl
  local.tee $6
  global.get $src/vortex/P
  i32.add
  local.tee $7
  local.get $5
  f32.store
  local.get $7
  local.get $1
  f32.store offset=4
  local.get $7
  local.get $2
  f32.store offset=8
  local.get $7
  f32.const 0
  f32.store offset=12
  global.get $src/vortex/V
  local.get $6
  i32.add
  local.tee $7
  f32.const 0
  f32.store
  local.get $7
  f32.const 0
  f32.store offset=4
  local.get $7
  f32.const 0
  f32.store offset=8
  local.get $7
  f32.const 0
  f32.store offset=12
  global.get $src/vortex/RNG
  i32.const 1664525
  i32.mul
  i32.const 1013904223
  i32.add
  global.set $src/vortex/RNG
  global.get $src/vortex/R
  local.get $6
  i32.add
  local.tee $6
  global.get $src/vortex/RNG
  i32.const 8
  i32.shr_u
  f32.convert_i32_u
  f32.const 5.9604644775390625e-08
  f32.mul
  f32.const 0.4399999976158142
  f32.mul
  f32.const 0.7799999713897705
  f32.add
  f32.store
  local.get $6
  f32.const 0
  f32.store offset=4
  local.get $6
  f32.const 0
  f32.store offset=8
  local.get $6
  f32.const 0
  f32.store offset=12
  local.get $0
  i32.const 2
  i32.shl
  local.tee $0
  global.get $src/vortex/D
  i32.add
  f32.const 0
  f32.store
  global.get $src/vortex/IDX
  local.get $0
  i32.add
  f32.const 0
  f32.const 31
  local.get $5
  f32.const 1.7999999523162842
  f32.add
  f32.const 8.88888931274414
  f32.mul
  local.tee $3
  local.get $3
  f32.const 31
  f32.gt
  select
  local.get $3
  f32.const 0
  f32.lt
  select
  i32.trunc_sat_f32_s
  f32.const 0
  f32.const 31
  local.get $1
  f32.const 1.7999999523162842
  f32.add
  f32.const 8.88888931274414
  f32.mul
  local.tee $1
  local.get $1
  f32.const 31
  f32.gt
  select
  local.get $1
  f32.const 0
  f32.lt
  select
  i32.trunc_sat_f32_s
  f32.const 0
  f32.const 31
  local.get $2
  f32.const 1.7999999523162842
  f32.add
  f32.const 8.88888931274414
  f32.mul
  local.tee $1
  local.get $1
  f32.const 31
  f32.gt
  select
  local.get $1
  f32.const 0
  f32.lt
  select
  i32.trunc_sat_f32_s
  i32.const 5
  i32.shl
  i32.add
  i32.const 5
  i32.shl
  i32.add
  i32.store
 )
 (func $src/vortex/reset
  (local $0 i32)
  global.get $src/vortex/SEED
  i32.const 1
  global.get $src/vortex/SEED
  select
  global.set $src/vortex/RNG
  i32.const 0
  global.set $src/vortex/FRAME
  i32.const 0
  global.set $src/vortex/ESCAPES
  loop $for-loop|0
   local.get $0
   i32.const 131072
   i32.lt_s
   if
    global.get $src/vortex/CEL
    local.get $0
    i32.const 2
    i32.shl
    i32.add
    f32.const 0
    f32.store
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|0
   end
  end
  i32.const 0
  local.set $0
  loop $for-loop|1
   local.get $0
   global.get $src/vortex/NV
   i32.lt_s
   if
    local.get $0
    call $src/vortex/spawn
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|1
   end
  end
  f32.const 0
  f32.const 0
  f32.const 0
  call $src/vortex/buildGrid
 )
 (func $~start
  i32.const 1452
  global.set $~lib/rt/stub/offset
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 2000000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufPos
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 2000000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufVel
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 2000000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufPrp
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 500000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufDbg
  i32.const 12
  i32.const 5
  call $~lib/rt/stub/__new
  i32.const 500000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufIdx
  i32.const 12
  i32.const 5
  call $~lib/rt/stub/__new
  i32.const 500000
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufSrt
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 131072
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufCel
  i32.const 12
  i32.const 5
  call $~lib/rt/stub/__new
  i32.const 32769
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufOff
  i32.const 12
  i32.const 5
  call $~lib/rt/stub/__new
  i32.const 32768
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufCur
  i32.const 12
  i32.const 5
  call $~lib/rt/stub/__new
  i32.const 32768
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufOcc
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 1024
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufNoise
  i32.const 12
  i32.const 4
  call $~lib/rt/stub/__new
  i32.const 4
  call $~lib/arraybuffer/ArrayBufferView#constructor
  global.set $src/vortex/bufOut
 )
 (func $src/vortex/verifyGrid (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 f32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  f32.const 0
  f32.const 0
  f32.const 0
  call $src/vortex/buildGrid
  loop $for-loop|0
   local.get $0
   i32.const 32768
   i32.lt_s
   if
    local.get $1
    global.get $src/vortex/CEL
    local.get $0
    i32.const 4
    i32.shl
    i32.add
    f32.load offset=12
    i32.trunc_sat_f32_s
    i32.add
    local.set $1
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|0
   end
  end
  local.get $1
  global.get $src/vortex/NV
  i32.ne
  if
   i32.const 1
   return
  end
  global.get $src/vortex/OFF
  i32.load
  if
   i32.const 2
   return
  end
  global.get $src/vortex/NV
  global.get $src/vortex/OFF
  i32.const 131072
  i32.add
  i32.load
  i32.ne
  if
   i32.const 3
   return
  end
  i32.const 0
  local.set $0
  loop $for-loop|1
   local.get $0
   i32.const 32768
   i32.lt_s
   if
    global.get $src/vortex/CEL
    local.get $0
    i32.const 4
    i32.shl
    i32.add
    f32.load offset=12
    i32.trunc_sat_f32_s
    global.get $src/vortex/OFF
    local.get $0
    i32.const 1
    i32.add
    i32.const 2
    i32.shl
    i32.add
    i32.load
    global.get $src/vortex/OFF
    local.get $0
    i32.const 2
    i32.shl
    i32.add
    i32.load
    i32.sub
    i32.ne
    if
     i32.const 4
     return
    end
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|1
   end
  end
  i32.const 0
  local.set $1
  loop $for-loop|2
   local.get $1
   i32.const 32768
   i32.lt_s
   if
    local.get $3
    global.get $src/vortex/OFF
    local.get $1
    i32.const 1
    i32.add
    i32.const 2
    i32.shl
    i32.add
    i32.load
    local.tee $4
    global.get $src/vortex/OFF
    local.get $1
    i32.const 2
    i32.shl
    i32.add
    i32.load
    local.tee $0
    i32.sub
    i32.add
    local.set $3
    loop $for-loop|3
     local.get $0
     local.get $4
     i32.lt_s
     if
      global.get $src/vortex/SRT
      local.get $0
      i32.const 2
      i32.shl
      i32.add
      i32.load
      local.tee $5
      i32.const 0
      i32.lt_s
      local.get $5
      global.get $src/vortex/NV
      i32.ge_s
      i32.or
      if
       i32.const 5
       return
      end
      local.get $1
      f32.const 0
      f32.const 31
      global.get $src/vortex/P
      local.get $5
      i32.const 4
      i32.shl
      i32.add
      local.tee $5
      f32.load
      f32.const 1.7999999523162842
      f32.add
      f32.const 8.88888931274414
      f32.mul
      local.tee $2
      local.get $2
      f32.const 31
      f32.gt
      select
      local.get $2
      f32.const 0
      f32.lt
      select
      i32.trunc_sat_f32_s
      f32.const 0
      f32.const 31
      local.get $5
      f32.load offset=4
      f32.const 1.7999999523162842
      f32.add
      f32.const 8.88888931274414
      f32.mul
      local.tee $2
      local.get $2
      f32.const 31
      f32.gt
      select
      local.get $2
      f32.const 0
      f32.lt
      select
      i32.trunc_sat_f32_s
      f32.const 0
      f32.const 31
      local.get $5
      f32.load offset=8
      f32.const 1.7999999523162842
      f32.add
      f32.const 8.88888931274414
      f32.mul
      local.tee $2
      local.get $2
      f32.const 31
      f32.gt
      select
      local.get $2
      f32.const 0
      f32.lt
      select
      i32.trunc_sat_f32_s
      i32.const 5
      i32.shl
      i32.add
      i32.const 5
      i32.shl
      i32.add
      i32.ne
      if
       i32.const 6
       return
      end
      local.get $0
      i32.const 1
      i32.add
      local.set $0
      br $for-loop|3
     end
    end
    local.get $1
    i32.const 1
    i32.add
    local.set $1
    br $for-loop|2
   end
  end
  local.get $3
  global.get $src/vortex/NV
  i32.ne
  if
   i32.const 7
   return
  end
  i32.const 0
 )
 (func $src/vortex/velPtr (result i32)
  global.get $src/vortex/V
 )
 (func $src/vortex/step (param $0 f32) (param $1 f32)
  (local $2 f32)
  (local $3 f32)
  (local $4 i32)
  (local $5 f32)
  (local $6 i32)
  (local $7 f32)
  (local $8 f32)
  (local $9 f32)
  (local $10 f32)
  (local $11 f32)
  (local $12 i32)
  (local $13 f32)
  (local $14 f32)
  (local $15 f32)
  (local $16 f32)
  (local $17 f32)
  (local $18 f32)
  (local $19 f32)
  (local $20 f32)
  (local $21 i32)
  (local $22 i32)
  global.get $src/vortex/PRESS
  f32.const 0.05000000074505806
  f32.const 0
  local.get $0
  local.get $0
  f32.const 0
  f32.lt
  select
  local.get $0
  f32.const 0.05000000074505806
  f32.gt
  select
  local.tee $5
  f32.mul
  f32.const 9
  f32.mul
  local.set $0
  global.get $src/vortex/GRID_INT
  i32.const 0
  i32.le_s
  if
   i32.const 1
   global.set $src/vortex/GRID_INT
  end
  global.get $src/vortex/FRAME
  global.get $src/vortex/GRID_INT
  i32.rem_s
  i32.eqz
  if
   local.get $1
   local.get $0
   global.get $src/vortex/TURB
   local.get $5
   f32.mul
   f32.const 2.4000000953674316
   f32.mul
   call $src/vortex/buildGrid
  end
  global.get $src/vortex/FRAME
  i32.const 1
  i32.add
  global.set $src/vortex/FRAME
  local.get $1
  f32.const 0.6299999952316284
  f32.mul
  call $~lib/math/NativeMathf.sin
  drop
  local.get $1
  f32.const 0.1899999976158142
  f32.mul
  local.tee $0
  local.get $0
  f32.add
  local.tee $0
  call $~lib/math/NativeMathf.cos
  local.set $8
  local.get $0
  call $~lib/math/NativeMathf.sin
  local.set $9
  f32.const 1
  global.get $src/vortex/STEER
  local.get $5
  f32.mul
  local.tee $0
  local.get $0
  f32.const 1
  f32.gt
  select
  local.set $7
  global.get $src/vortex/CONF
  local.get $5
  f32.mul
  f32.const 0.19359999895095825
  f32.div
  local.set $10
  global.get $src/vortex/MR
  global.get $src/vortex/MR
  f32.mul
  local.set $11
  loop $for-loop|0
   local.get $4
   global.get $src/vortex/NV
   i32.lt_s
   if
    local.get $4
    i32.const 4
    i32.shl
    local.tee $12
    global.get $src/vortex/V
    i32.add
    local.tee $6
    f32.load
    local.set $2
    local.get $6
    f32.load offset=4
    local.set $3
    local.get $6
    f32.load offset=8
    local.set $14
    global.get $src/vortex/R
    local.get $12
    i32.add
    f32.load
    local.set $15
    f32.const 1
    global.get $src/vortex/P
    local.get $12
    i32.add
    local.tee $12
    f32.load
    local.tee $16
    local.get $16
    f32.mul
    local.get $12
    f32.load offset=8
    local.tee $17
    local.get $17
    f32.mul
    f32.add
    f32.sqrt
    f32.const 9.999999747378752e-06
    f32.add
    local.tee $0
    f32.div
    local.set $18
    local.get $0
    f32.const -1
    f32.add
    local.tee $0
    local.get $0
    f32.mul
    local.get $12
    f32.load offset=4
    local.tee $13
    local.get $13
    f32.mul
    f32.add
    f32.const 5.165289402008057
    f32.mul
    local.set $1
    local.get $0
    global.set $src/vortex/Q_RHO
    local.get $18
    global.set $src/vortex/Q_INVR
    local.get $1
    global.set $src/vortex/Q_U2
    local.get $17
    f32.neg
    local.get $18
    f32.mul
    global.get $src/vortex/SPIN
    local.get $15
    f32.mul
    local.get $1
    f32.const 3
    f32.mul
    f32.const 1
    f32.add
    f32.div
    local.tee $1
    f32.mul
    global.get $src/vortex/POLO
    f32.neg
    local.get $15
    f32.mul
    local.get $0
    local.get $9
    f32.mul
    local.get $13
    local.get $8
    f32.mul
    f32.add
    f32.mul
    local.tee $19
    local.get $16
    local.get $18
    f32.mul
    local.tee $20
    f32.mul
    f32.add
    global.set $src/vortex/FX
    global.get $src/vortex/POLO
    local.get $15
    f32.mul
    local.get $0
    local.get $8
    f32.mul
    local.get $13
    local.get $9
    f32.mul
    f32.sub
    f32.mul
    global.set $src/vortex/FY
    local.get $20
    local.get $1
    f32.mul
    local.get $19
    local.get $17
    local.get $18
    f32.mul
    f32.mul
    f32.add
    global.set $src/vortex/FZ
    local.get $2
    global.get $src/vortex/FX
    local.get $2
    f32.sub
    local.get $7
    f32.mul
    f32.add
    local.set $1
    local.get $3
    global.get $src/vortex/FY
    local.get $3
    f32.sub
    local.get $7
    f32.mul
    f32.add
    local.set $0
    local.get $14
    global.get $src/vortex/FZ
    local.get $14
    f32.sub
    local.get $7
    f32.mul
    f32.add
    local.set $2
    global.get $src/vortex/Q_U2
    local.tee $3
    f32.const 1
    f32.gt
    if
     local.get $1
     local.get $10
     f32.neg
     local.get $3
     f32.const -1
     f32.add
     f32.mul
     local.tee $3
     global.get $src/vortex/Q_RHO
     global.get $src/vortex/Q_INVR
     f32.mul
     f32.mul
     local.tee $14
     local.get $16
     f32.mul
     f32.add
     local.set $1
     local.get $2
     local.get $14
     local.get $17
     f32.mul
     f32.add
     local.set $2
     local.get $0
     local.get $3
     local.get $13
     f32.mul
     f32.add
     local.set $0
    end
    local.get $1
    local.get $4
    i32.const 2
    i32.shl
    local.tee $21
    global.get $src/vortex/IDX
    i32.add
    i32.load
    i32.const 4
    i32.shl
    local.tee $22
    global.get $src/vortex/CEL
    i32.add
    f32.load
    f32.add
    local.set $1
    local.get $0
    global.get $src/vortex/CEL
    local.get $22
    i32.add
    local.tee $22
    f32.load offset=4
    f32.add
    local.set $0
    local.get $2
    local.get $22
    f32.load offset=8
    f32.add
    local.set $2
    global.get $src/vortex/DBG_ON
    if
     global.get $src/vortex/D
     local.get $21
     i32.add
     local.get $22
     f32.load offset=12
     global.get $src/vortex/INV_DEN
     f32.mul
     f32.store
    end
    global.get $src/vortex/MS
    f32.const 0
    f32.ne
    if
     local.get $11
     local.get $16
     global.get $src/vortex/MX
     f32.sub
     local.tee $3
     local.get $3
     f32.mul
     local.get $13
     global.get $src/vortex/MY
     f32.sub
     local.tee $14
     local.get $14
     f32.mul
     f32.add
     local.get $17
     global.get $src/vortex/MZ
     f32.sub
     local.tee $15
     local.get $15
     f32.mul
     f32.add
     local.tee $18
     f32.gt
     local.get $18
     f32.const 9.99999993922529e-09
     f32.gt
     i32.and
     if
      local.get $1
      local.get $3
      global.get $src/vortex/MS
      local.get $5
      f32.mul
      f32.const 34
      f32.mul
      f32.const 1
      local.get $18
      f32.sqrt
      local.tee $1
      global.get $src/vortex/MR
      f32.div
      f32.sub
      f32.mul
      local.get $1
      f32.div
      local.tee $3
      f32.mul
      f32.add
      local.set $1
      local.get $2
      local.get $15
      local.get $3
      f32.mul
      f32.add
      local.set $2
      local.get $0
      local.get $14
      local.get $3
      f32.mul
      f32.add
      local.set $0
     end
    end
    local.get $1
    local.get $1
    f32.mul
    local.get $0
    local.get $0
    f32.mul
    f32.add
    local.get $2
    local.get $2
    f32.mul
    f32.add
    local.tee $3
    f32.const 11.5600004196167
    f32.gt
    if
     local.get $1
     f32.const 3.4000000953674316
     local.get $3
     f32.sqrt
     f32.div
     local.tee $14
     f32.mul
     local.set $1
     local.get $2
     local.get $14
     f32.mul
     local.set $2
     f32.const 11.5600004196167
     local.set $3
     local.get $0
     local.get $14
     f32.mul
     local.set $0
    end
    block $for-continue|0
     local.get $16
     local.get $1
     local.get $5
     f32.mul
     f32.add
     local.tee $14
     local.get $14
     f32.mul
     local.get $13
     local.get $0
     local.get $5
     f32.mul
     f32.add
     local.tee $13
     local.get $13
     f32.mul
     f32.add
     local.get $17
     local.get $2
     local.get $5
     f32.mul
     f32.add
     local.tee $15
     local.get $15
     f32.mul
     f32.add
     f32.const 3.239999771118164
     f32.gt
     if
      global.get $src/vortex/ESCAPES
      i32.const 1
      i32.add
      global.set $src/vortex/ESCAPES
      local.get $4
      call $src/vortex/spawn
      br $for-continue|0
     end
     global.get $src/vortex/IDX
     local.get $4
     i32.const 2
     i32.shl
     i32.add
     f32.const 0
     f32.const 31
     local.get $14
     f32.const 1.7999999523162842
     f32.add
     f32.const 8.88888931274414
     f32.mul
     local.tee $16
     local.get $16
     f32.const 31
     f32.gt
     select
     local.get $16
     f32.const 0
     f32.lt
     select
     i32.trunc_sat_f32_s
     f32.const 0
     f32.const 31
     local.get $13
     f32.const 1.7999999523162842
     f32.add
     f32.const 8.88888931274414
     f32.mul
     local.tee $16
     local.get $16
     f32.const 31
     f32.gt
     select
     local.get $16
     f32.const 0
     f32.lt
     select
     i32.trunc_sat_f32_s
     f32.const 0
     f32.const 31
     local.get $15
     f32.const 1.7999999523162842
     f32.add
     f32.const 8.88888931274414
     f32.mul
     local.tee $16
     local.get $16
     f32.const 31
     f32.gt
     select
     local.get $16
     f32.const 0
     f32.lt
     select
     i32.trunc_sat_f32_s
     i32.const 5
     i32.shl
     i32.add
     i32.const 5
     i32.shl
     i32.add
     i32.store
     local.get $12
     local.get $14
     f32.store
     local.get $12
     local.get $13
     f32.store offset=4
     local.get $12
     local.get $15
     f32.store offset=8
     local.get $12
     local.get $3
     f32.const 0.08650518953800201
     f32.mul
     f32.store offset=12
     local.get $6
     local.get $1
     f32.store
     local.get $6
     local.get $0
     f32.store offset=4
     local.get $6
     local.get $2
     f32.store offset=8
    end
    local.get $4
    i32.const 1
    i32.add
    local.set $4
    br $for-loop|0
   end
  end
 )
 (func $src/vortex/sortedPtr (result i32)
  global.get $src/vortex/SRT
 )
 (func $src/vortex/setMouse (param $0 f32) (param $1 f32) (param $2 f32) (param $3 f32) (param $4 f32)
  local.get $0
  global.set $src/vortex/MX
  local.get $1
  global.set $src/vortex/MY
  local.get $2
  global.set $src/vortex/MZ
  local.get $3
  f32.const 1.0000000474974513e-03
  local.get $3
  f32.const 1.0000000474974513e-03
  f32.gt
  select
  global.set $src/vortex/MR
  local.get $4
  global.set $src/vortex/MS
 )
 (func $src/vortex/setGridInterval (param $0 i32)
  i32.const 1
  i32.const 8
  local.get $0
  local.get $0
  i32.const 8
  i32.gt_s
  select
  local.get $0
  i32.const 0
  i32.le_s
  select
  global.set $src/vortex/GRID_INT
 )
 (func $src/vortex/setFlow (param $0 f32) (param $1 f32) (param $2 f32) (param $3 f32) (param $4 f32) (param $5 f32)
  local.get $0
  global.set $src/vortex/SPIN
  local.get $1
  global.set $src/vortex/POLO
  local.get $2
  global.set $src/vortex/TURB
  local.get $3
  global.set $src/vortex/CONF
  local.get $4
  global.set $src/vortex/STEER
  local.get $5
  global.set $src/vortex/PRESS
 )
 (func $src/vortex/setDebug (param $0 i32)
  local.get $0
  i32.const 0
  i32.ne
  global.set $src/vortex/DBG_ON
 )
 (func $src/vortex/prpPtr (result i32)
  global.get $src/vortex/R
 )
 (func $src/vortex/posPtr (result i32)
  global.get $src/vortex/P
 )
 (func $src/vortex/poke (param $0 i32) (param $1 f32) (param $2 f32) (param $3 f32) (param $4 f32) (param $5 f32) (param $6 f32)
  (local $7 i32)
  local.get $0
  i32.const 0
  i32.lt_s
  local.get $0
  global.get $src/vortex/NV
  i32.ge_s
  i32.or
  if
   return
  end
  local.get $0
  i32.const 4
  i32.shl
  local.tee $7
  global.get $src/vortex/P
  i32.add
  local.tee $0
  local.get $1
  f32.store
  local.get $0
  local.get $2
  f32.store offset=4
  local.get $0
  local.get $3
  f32.store offset=8
  local.get $0
  f32.const 0
  f32.store offset=12
  global.get $src/vortex/V
  local.get $7
  i32.add
  local.tee $0
  local.get $4
  f32.store
  local.get $0
  local.get $5
  f32.store offset=4
  local.get $0
  local.get $6
  f32.store offset=8
  local.get $0
  f32.const 0
  f32.store offset=12
 )
 (func $src/vortex/nanCount (result i32)
  (local $0 f32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 f32)
  loop $for-loop|0
   local.get $1
   global.get $src/vortex/NV
   i32.lt_s
   if
    global.get $src/vortex/P
    local.get $1
    i32.const 4
    i32.shl
    i32.add
    local.tee $3
    f32.load
    local.set $0
    local.get $2
    i32.const 1
    i32.add
    local.get $2
    local.get $3
    f32.load offset=4
    local.tee $4
    local.get $4
    f32.ne
    local.get $0
    local.get $0
    f32.ne
    i32.or
    local.get $3
    f32.load offset=8
    local.tee $0
    local.get $0
    f32.ne
    i32.or
    select
    local.set $2
    local.get $1
    i32.const 1
    i32.add
    local.set $1
    br $for-loop|0
   end
  end
  local.get $2
 )
 (func $src/vortex/meanTubeRadius (result f32)
  (local $0 f32)
  (local $1 i32)
  (local $2 i32)
  loop $for-loop|0
   local.get $1
   global.get $src/vortex/NV
   i32.lt_s
   if
    local.get $0
    global.get $src/vortex/P
    local.get $1
    i32.const 4
    i32.shl
    i32.add
    local.tee $2
    f32.load
    local.tee $0
    local.get $0
    f32.mul
    local.get $2
    f32.load offset=8
    local.tee $0
    local.get $0
    f32.mul
    f32.add
    f32.sqrt
    f32.const -1
    f32.add
    local.tee $0
    local.get $0
    f32.mul
    local.get $2
    f32.load offset=4
    local.tee $0
    local.get $0
    f32.mul
    f32.add
    f32.sqrt
    f32.add
    local.set $0
    local.get $1
    i32.const 1
    i32.add
    local.set $1
    br $for-loop|0
   end
  end
  global.get $src/vortex/NV
  i32.const 0
  i32.gt_s
  if (result f32)
   local.get $0
   global.get $src/vortex/NV
   f32.convert_i32_s
   f32.div
  else
   f32.const 0
  end
 )
 (func $src/vortex/meanSpeed2 (result f32)
  (local $0 i32)
  (local $1 f32)
  loop $for-loop|0
   local.get $0
   global.get $src/vortex/NV
   i32.lt_s
   if
    local.get $1
    global.get $src/vortex/P
    local.get $0
    i32.const 4
    i32.shl
    i32.add
    f32.load offset=12
    f32.add
    local.set $1
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|0
   end
  end
  global.get $src/vortex/NV
  i32.const 0
  i32.gt_s
  if (result f32)
   local.get $1
   global.get $src/vortex/NV
   f32.convert_i32_s
   f32.div
  else
   f32.const 0
  end
 )
 (func $src/vortex/maxAbsCoord (result f32)
  (local $0 f32)
  (local $1 f32)
  (local $2 i32)
  (local $3 i32)
  (local $4 f32)
  (local $5 f32)
  loop $for-loop|0
   local.get $2
   global.get $src/vortex/NV
   i32.lt_s
   if
    global.get $src/vortex/P
    local.get $2
    i32.const 4
    i32.shl
    i32.add
    local.tee $3
    f32.load
    local.set $4
    local.get $3
    f32.load offset=4
    local.set $5
    local.get $3
    f32.load offset=8
    local.set $1
    local.get $4
    f32.const 0
    f32.lt
    if (result f32)
     local.get $4
     f32.neg
     local.tee $4
     local.get $0
     f32.gt
     if (result f32)
      local.get $4
     else
      local.get $0
     end
    else
     local.get $4
     local.get $0
     local.get $0
     local.get $4
     f32.lt
     select
    end
    local.set $0
    local.get $5
    f32.const 0
    f32.lt
    if (result f32)
     local.get $5
     f32.neg
     local.tee $4
     local.get $0
     f32.gt
     if (result f32)
      local.get $4
     else
      local.get $0
     end
    else
     local.get $5
     local.get $0
     local.get $0
     local.get $5
     f32.lt
     select
    end
    local.set $0
    local.get $1
    f32.const 0
    f32.lt
    if (result f32)
     local.get $1
     f32.neg
     local.tee $1
     local.get $0
     f32.gt
     if (result f32)
      local.get $1
     else
      local.get $0
     end
    else
     local.get $1
     local.get $0
     local.get $0
     local.get $1
     f32.lt
     select
    end
    local.set $0
    local.get $2
    i32.const 1
    i32.add
    local.set $2
    br $for-loop|0
   end
  end
  local.get $0
 )
 (func $src/vortex/init (param $0 i32) (param $1 i32)
  global.get $src/vortex/bufPos
  i32.load offset=4
  global.set $src/vortex/P
  global.get $src/vortex/bufVel
  i32.load offset=4
  global.set $src/vortex/V
  global.get $src/vortex/bufPrp
  i32.load offset=4
  global.set $src/vortex/R
  global.get $src/vortex/bufDbg
  i32.load offset=4
  global.set $src/vortex/D
  global.get $src/vortex/bufIdx
  i32.load offset=4
  global.set $src/vortex/IDX
  global.get $src/vortex/bufSrt
  i32.load offset=4
  global.set $src/vortex/SRT
  global.get $src/vortex/bufCel
  i32.load offset=4
  global.set $src/vortex/CEL
  global.get $src/vortex/bufOff
  i32.load offset=4
  global.set $src/vortex/OFF
  global.get $src/vortex/bufCur
  i32.load offset=4
  global.set $src/vortex/CUR
  global.get $src/vortex/bufOcc
  i32.load offset=4
  global.set $src/vortex/OCC
  global.get $src/vortex/bufOut
  i32.load offset=4
  global.set $src/vortex/OUT
  i32.const 0
  global.set $src/vortex/NOISE_READY
  local.get $1
  global.set $src/vortex/SEED
  i32.const 1
  i32.const 500000
  local.get $0
  local.get $0
  i32.const 500000
  i32.gt_s
  select
  local.get $0
  i32.const 0
  i32.le_s
  select
  global.set $src/vortex/NV
  call $src/vortex/reset
 )
 (func $src/vortex/getTargetDensity (result f32)
  global.get $src/vortex/TARGET_DEN
 )
 (func $src/vortex/getOccupancy (result i32)
  global.get $src/vortex/NOCC
 )
 (func $src/vortex/getMaxParticles (result i32)
  i32.const 500000
 )
 (func $src/vortex/getGridInterval (result i32)
  global.get $src/vortex/GRID_INT
 )
 (func $src/vortex/getGridDim (result i32)
  i32.const 32
 )
 (func $src/vortex/getGridCells (result i32)
  i32.const 32768
 )
 (func $src/vortex/getFrame (result i32)
  global.get $src/vortex/FRAME
 )
 (func $src/vortex/getEscapes (result i32)
  global.get $src/vortex/ESCAPES
 )
 (func $src/vortex/getCount (result i32)
  global.get $src/vortex/NV
 )
 (func $src/vortex/flowSample (param $0 f32) (param $1 f32) (param $2 f32)
  (local $3 f32)
  (local $4 f32)
  (local $5 f32)
  (local $6 f32)
  f32.const 1
  local.get $0
  local.get $0
  f32.mul
  local.get $2
  local.get $2
  f32.mul
  f32.add
  f32.sqrt
  f32.const 9.999999747378752e-06
  f32.add
  local.tee $4
  f32.div
  local.set $3
  local.get $4
  f32.const -1
  f32.add
  local.tee $4
  local.get $4
  f32.mul
  local.get $1
  local.get $1
  f32.mul
  f32.add
  f32.const 5.165289402008057
  f32.mul
  local.set $5
  local.get $4
  global.set $src/vortex/Q_RHO
  local.get $3
  global.set $src/vortex/Q_INVR
  local.get $5
  global.set $src/vortex/Q_U2
  local.get $2
  f32.neg
  local.get $3
  f32.mul
  global.get $src/vortex/SPIN
  local.get $5
  f32.const 3
  f32.mul
  f32.const 1
  f32.add
  f32.div
  local.tee $5
  f32.mul
  global.get $src/vortex/POLO
  f32.neg
  local.get $4
  f32.const 0
  f32.mul
  local.get $1
  f32.add
  f32.mul
  local.tee $6
  local.get $0
  local.get $3
  f32.mul
  local.tee $0
  f32.mul
  f32.add
  global.set $src/vortex/FX
  global.get $src/vortex/POLO
  local.get $4
  local.get $1
  f32.const 0
  f32.mul
  f32.sub
  f32.mul
  global.set $src/vortex/FY
  local.get $0
  local.get $5
  f32.mul
  local.get $6
  local.get $2
  local.get $3
  f32.mul
  f32.mul
  f32.add
  global.set $src/vortex/FZ
  global.get $src/vortex/OUT
  global.get $src/vortex/FX
  f32.store
  global.get $src/vortex/OUT
  global.get $src/vortex/FY
  f32.store offset=4
  global.get $src/vortex/OUT
  global.get $src/vortex/FZ
  f32.store offset=8
  global.get $src/vortex/OUT
  global.get $src/vortex/Q_U2
  f32.store offset=12
 )
 (func $src/vortex/flowOut (result i32)
  global.get $src/vortex/OUT
 )
 (func $src/vortex/escapeFraction (result f32)
  (local $0 f32)
  (local $1 i32)
  (local $2 i32)
  loop $for-loop|0
   local.get $2
   global.get $src/vortex/NV
   i32.lt_s
   if
    local.get $1
    i32.const 1
    i32.add
    local.get $1
    global.get $src/vortex/P
    local.get $2
    i32.const 4
    i32.shl
    i32.add
    local.tee $1
    f32.load
    local.tee $0
    local.get $0
    f32.mul
    local.get $1
    f32.load offset=8
    local.tee $0
    local.get $0
    f32.mul
    f32.add
    f32.sqrt
    f32.const -1
    f32.add
    local.tee $0
    local.get $0
    f32.mul
    local.get $1
    f32.load offset=4
    local.tee $0
    local.get $0
    f32.mul
    f32.add
    f32.const 0.49561598896980286
    f32.gt
    select
    local.set $1
    local.get $2
    i32.const 1
    i32.add
    local.set $2
    br $for-loop|0
   end
  end
  global.get $src/vortex/NV
  i32.const 0
  i32.gt_s
  if (result f32)
   local.get $1
   f32.convert_i32_s
   global.get $src/vortex/NV
   f32.convert_i32_s
   f32.div
  else
   f32.const 0
  end
 )
 (func $src/vortex/dbgPtr (result i32)
  global.get $src/vortex/D
 )
 (func $src/vortex/cellPtr (result i32)
  global.get $src/vortex/CEL
 )
)
