@echo off
%1\bin\java -cp "%~dp0*" -Duser.home="%~dp0\..\logs" -Djava.util.logging.config.file="%~dp0logging.properties" quadric.blockvaulter.BlockVaulter %2 %3 %4 %5 %6 %7
