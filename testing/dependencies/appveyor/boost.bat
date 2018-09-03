rem Finally found a use for De Morgan's laws of boolean algebra!
rem We can't use logical OR in IF statements, so we check for the negation of
rem the AND (implicit when chaining IF-s) of the negation of each separate statement
set nonVSGenerator=true
if not "%CMAKE_GENERATOR%"=="Ninja" if not "%CMAKE_GENERATOR%"=="MSYS Makefiles" set nonVSGenerator=false

if "%nonVSGenerator%"=="true" (
  echo "Using non-VS generator %CMAKE_GENERATOR%"
  echo "Nothing to do here!"
) else (
  echo "Using VS generator %CMAKE_GENERATOR%"
  echo "Configuring, building, and installing Boost"

  rem Download
  bash -c "curl -LOs https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.zip"
  bash -c "7z x boost_1_66_0.zip"
  
  rem Configure
  cd boost_1_66_0
  bootstrap.bat --with-toolset=msvc --with-python="C:\Python37-x64\python.exe" --with-libraries=filesystem,system,test,python --prefix="C:\Deps\boost_1.66.0"
  rem Build and install
  b2 -q install link=static,shared threading=multi variant=release toolset=msvc --with-filesystem --with-test --with-system --with-python --prefix="C:\Deps\boost_1.66.0"
  rem Clean up
  cd ..
  rmdir boost_1_66_0 boost_1_66_0.zip
)