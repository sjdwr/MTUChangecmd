@echo off
color f0
echo 주의 : 관리자 권한으로 실행하세요 
echo.

:MTU_LOOP
echo MTU를 적으세요. ( 범위 : 0 ~ 10000, 기본값 : 1500, 권장 200~400 )

set /p MTU= 																			
if %MTU% LSS 0 goto MTU_LOOP 															
if %MTU% GTR 10000 goto MTU_LOOP 														

FOR /f "tokens=2 delims==" %%a IN ('wmic os get Version /value') DO ( 	
	FOR /f "tokens=1-3 delims=." %%b IN ("%%a") DO ( 		
		cls 																																				
		
		if %%b EQU 10 if %%d GEQ 17763 (
			echo Windows 10 redstone 5 이상입니다.
			echo.
			goto YES 
		)
		
		goto NO 
	)
)

:YES
netsh int ipv4 set global minmtu=352 
if %MTU% LSS 352 set MTU=352

:NO
set /a _sum_=0
FOR /F %%A IN ('netsh interface ipv4 show interfaces') DO (
  if %%A GTR 1 if %%A LEQ 100 ( 
	netsh interface ipv4 set subinterface "%%A" mtu=%MTU% store=persistent
	set /a _sum_+=1 
  )
)
 
echo 총 %_sum_% 개 적용 완료. 꺼도 됩니다.
pause