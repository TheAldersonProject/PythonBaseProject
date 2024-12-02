#!/usr/bin/env python3

"""This is the Setup file for the app files."""

from pathlib import Path

from setuptools import find_packages, setup

with Path("README.md").open(encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    # Basic project information
    name="python-base-project",
    version="0.1.0",
    author="Your Name",
    author_email="your.email@example.com",
    description="Type here the description for your project.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    # Project URLs
    project_urls={
        "Source Code": "https://github.com/Thealdersonproject/python-base-project",
    },
    # Package discovery
    package_dir={"": "app"},  # Directory containing the package
    packages=find_packages(where="app"),
    # Package data
    include_package_data=True,
    package_data={
        "": ["*.json", "*.yaml"],  # Include all json and yaml files
    },
    # Dependencies
    python_requires="==3.11.9",
    install_requires=[
        "python-dotenv==1.0.1",
    ],
    extras_require={
        "dev": [
            "black==24.10.0",
            "isort==5.13.2",
            "pyright==1.1.388",
            "pytest==8.3.3",
            "ruff==0.7.1",
            "typos==1.26.8",
        ],
        "test": [
            "pytest==8.3.3",
        ],
        "docs": [
            "sphinx",
            "sphinx-rtd-theme",
        ],
    },
    # Entry points
    entry_points={
        "console_scripts": [
            "my-command=app.main:main",
        ],
    },
    # Classifiers help users find your project
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3.11",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    # Additional metadata
    keywords="python, base, project",
    license="BSD 3-Clause License",
    platforms=["any"],
    zip_safe=False,
)
