@echo off
color f0
echo ���� : ������ �������� �����ϼ��� 
echo.

:MTU_LOOP
echo MTU�� ��������. ( ���� : 0 ~ 10000, �⺻�� : 1500, ���� 200~400 )

set /p MTU= 																			
if %MTU% LSS 0 goto MTU_LOOP 															
if %MTU% GTR 10000 goto MTU_LOOP 														

FOR /f "tokens=2 delims==" %%a IN ('wmic os get Version /value') DO ( 	
	FOR /f "tokens=1-3 delims=." %%b IN ("%%a") DO ( 		
		cls 																																				
		
		if %%b EQU 10 if %%d GEQ 17763 (
			echo Windows 10 redstone 5 �̻��Դϴ�.
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
 
echo �� %_sum_% �� ���� �Ϸ�. ���� �˴ϴ�.
pause