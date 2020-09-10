from setuptools import setup, find_namespace_packages

setup(
    setup_requires=["pbr"],
    pbr=True,
    package_dir={"": "src"},
    packages=find_namespace_packages(where="src"),
)
