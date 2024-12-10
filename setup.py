#!/usr/bin/env python3
"""This is the Setup file for the app files."""

import tomllib
from pathlib import Path
from typing import Any

from setuptools import find_packages, setup

with Path("README.md").open(encoding="utf-8") as fh:
    long_description = fh.read()

def load_pyproject_toml(file_path: Path) -> dict[str, Any]:
    """Load the pyproject.toml file and return its contents as a dictionary."""
    with file_path.open("rb") as f:
        return tomllib.load(f)

pyproject_content: dict[str, Any] = load_pyproject_toml(Path("pyproject.toml"))
project_info: dict[str, Any] = pyproject_content["project"]
project_dependencies_dev: list[str] = pyproject_content["tool"]["uv"]["dev-dependencies"]

setup(
    # Basic project information
    name=project_info["name"],
    version=project_info["version"],
    author=project_info["authors"][0],
    author_email=project_info["authors"][0],
    description=project_info["description"],
    long_description=long_description,
    long_description_content_type="text/markdown",
    # Project URLs
    project_urls={
        "Source Code": project_info["url"],
    },
    # Package discovery
    package_dir={"": project_info["package-dir"]},  # Directory containing the package
    packages=find_packages(where=project_info["package-dir"]),
    # Package data
    include_package_data=True,
    package_data={
        "": ["*.json", "*.yaml", "*.pyi"],
    },
    # Dependencies
    python_requires=project_info["requires-python"],
    install_requires = project_info["dependencies"],
    extras_require={
        "dev": project_dependencies_dev,
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
        f"Programming Language :: Python :: {project_info['requires-python']}",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],

    # Additional metadata
    keywords="python, base, project",
    license="BSD 3-Clause License",
    platforms=["any"],
    zip_safe=False,
)
