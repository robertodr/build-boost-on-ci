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

  rem now install Boost
  bash -c "curl -LOs https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.zip &&
           unzip -qq boost_1_66_0.zip &&
           cd boost_1_66_0"
  dir .
  rem Configure
  rem ./bootstrap.sh \
  rem     --with-toolset=gcc \
  rem     --with-libraries=filesystem,system,test,python \
  rem     --with-python="$PYTHON3" \
  rem     --prefix="C:\Deps\boost_1.66.0" &> /dev/null
  rem Build and install
  rem ./b2 -q install \
  rem      link=shared \
  rem      threading=multi \
  rem      variant=release \
  rem      toolset=gcc-7 \
  rem      --with-filesystem \
  rem      --with-test \
  rem      --with-system \
  rem      --with-python &> /dev/null
  rem Clean up
)