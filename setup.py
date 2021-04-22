import setuptools

setuptools.setup(
    name="test-package-name",
    version="0.2.0",
    packages=setuptools.find_packages(),
    extras_require={
          'testing': [
                "pytest-runner",
                "pytest"
            ]
    },
    classifiers=[
        "Programming Language :: Python :: 3",
    ],
    python_requires='>=3.6',
)

