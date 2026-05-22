# Module Testbenches

`mux2_1`, `mux3_3`, `dff_async_reset` 자체 테스트벤치는 제외했습니다.
단, 다른 모듈을 컴파일할 때 내부 의존성 때문에 해당 파일들이 함께 필요할 수 있습니다.

Icarus Verilog가 설치되어 있으면 프로젝트 루트에서 아래 명령으로 전체 실행할 수 있습니다.

```powershell
.\module_testbenches\run_all_iverilog.ps1
```

개별 실행 예시는 아래와 같습니다.

```powershell
iverilog -g2005 -o .\module_testbenches\out\tb_move_encoder.vvp .\module_testbenches\tb_move_encoder.v .\각모듈\move_encoder.v
vvp .\module_testbenches\out\tb_move_encoder.vvp
```

Vivado/ModelSim 등에서는 테스트벤치 파일과 필요한 DUT/하위 모듈 파일을 같이 compile한 뒤, `tb_*` 모듈을 simulation top으로 지정하면 됩니다.
