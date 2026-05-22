$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $PSScriptRoot "out"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$tests = @(
    @{
        Name = "move_encoder"
        Sources = @(
            "module_testbenches/tb_move_encoder.v",
            "각모듈/move_encoder.v"
        )
    },
    @{
        Name = "countdown_decoder"
        Sources = @(
            "module_testbenches/tb_countdown_decoder.v",
            "각모듈/countdown_decoder.v"
        )
    },
    @{
        Name = "decoder2to4"
        Sources = @(
            "module_testbenches/tb_decoder2to4.v",
            "각모듈/decoder2to4.v"
        )
    },
    @{
        Name = "obstacle_generator"
        Sources = @(
            "module_testbenches/tb_obstacle_generator.v",
            "각모듈/obstacle_generator.v",
            "각모듈/decoder2to4.v"
        )
    },
    @{
        Name = "collision_detector"
        Sources = @(
            "module_testbenches/tb_collision_detector.v",
            "각모듈/collision_detector.v"
        )
    },
    @{
        Name = "ship_move_logic"
        Sources = @(
            "module_testbenches/tb_ship_move_logic.v",
            "각모듈/ship_move_logic.v",
            "각모듈/mux3_3.v"
        )
    },
    @{
        Name = "ship_register"
        Sources = @(
            "module_testbenches/tb_ship_register.v",
            "각모듈/ship_register.v",
            "각모듈/mux2_1.v",
            "각모듈/dff_async_reset.v"
        )
    },
    @{
        Name = "countdown_counter"
        Sources = @(
            "module_testbenches/tb_countdown_counter.v",
            "각모듈/countdown_counter.v",
            "각모듈/mux2_1.v",
            "각모듈/dff_async_reset.v"
        )
    },
    @{
        Name = "obstacle_counter"
        Sources = @(
            "module_testbenches/tb_obstacle_counter.v",
            "각모듈/obstacle_counter.v",
            "각모듈/mux2_1.v",
            "각모듈/dff_async_reset.v"
        )
    },
    @{
        Name = "game_control"
        Sources = @(
            "module_testbenches/tb_game_control.v",
            "각모듈/game_control.v",
            "각모듈/mux2_1.v",
            "각모듈/dff_async_reset.v"
        )
    }
)

$failed = 0

foreach ($test in $tests) {
    $exe = Join-Path $outDir ("tb_" + $test.Name + ".vvp")
    $sources = @()
    foreach ($source in $test.Sources) {
        $sources += (Join-Path $root $source)
    }

    Write-Host "== $($test.Name) =="
    & iverilog -g2005 -o $exe @sources
    if ($LASTEXITCODE -ne 0) {
        $failed++
        continue
    }

    & vvp $exe
    if ($LASTEXITCODE -ne 0) {
        $failed++
    }
}

if ($failed -ne 0) {
    Write-Host "FAILED: $failed test(s)"
    exit 1
}

Write-Host "ALL TESTS PASSED"
