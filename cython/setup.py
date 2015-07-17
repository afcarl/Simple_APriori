from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'A priori algorithm',
  ext_modules = cythonize("apriori.pyx"),
)