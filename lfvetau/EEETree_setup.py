
# Tools to compile cython proxy class
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(ext_modules=[Extension(
    "EEETree",                 # name of extension
    ["EEETree.pyx"], #  our Cython source
    include_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc472/cms/cmssw/CMSSW_5_3_14/external/slc6_amd64_gcc472/bin/../../../../../../lcg/root/5.32.00/include'],
    library_dirs=['/cvmfs/cms.cern.ch/slc6_amd64_gcc472/cms/cmssw/CMSSW_5_3_14/external/slc6_amd64_gcc472/bin/../../../../../../lcg/root/5.32.00/lib'],
    libraries=['Tree', 'Core', 'TreePlayer'],
    language="c++")],  # causes Cython to create C++ source
    cmdclass={'build_ext': build_ext})
