
# Tools to compile cython proxy class
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension(
    "MuMuMuTree",                 # name of extension
    ["MuMuMuTree.pyx"], #  our Cython source
    include_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_24/external/slc6_amd64_gcc530/bin/../../../../../../../slc6_amd64_gcc530/lcg/root/6.06.00-ikhhed5/include'],
    library_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc530/cms/cmssw/CMSSW_8_0_24/external/slc6_amd64_gcc530/bin/../../../../../../../slc6_amd64_gcc530/lcg/root/6.06.00-ikhhed5/lib'],
    libraries=['Tree', 'Core', 'TreePlayer'],
    language="c++", 
    extra_compile_args=['-std=c++11', '-fno-var-tracking-assignments'])],  # causes Cython to create C++ source
    cmdclass={'build_ext': build_ext})