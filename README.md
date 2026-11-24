# Python + R Project Template

A reproducible project environment for Python and R, managed with **Micromamba** and **direnv**, and designed for use with **Visual Studio Code** and **Jupyter Notebooks**.

This template provides an isolated environment for each project. Python and R, their packages, language servers, Jupyter kernels, and development tools are installed in the project environment rather than the system installation.

The goal is to make projects easy to reproduce on another computer, including an office computer.

---

## 1. Features

- Python 3.12
- R 4.5
- Isolated project-specific Micromamba environment
- Automatic environment activation with `direnv`
- Python development with VS Code and Pylance
- R development with VS Code and the R extension
- Python and R Jupyter kernels
- Python linting and formatting with Ruff
- R formatting with Styler
- R language support through `languageserver`
- Shared VS Code project settings
- Reproducible package installation through `environment.yml`

---

## 2. Prerequisites

The setup assumes:

- Ubuntu Linux (64-bit)
- Bash shell
- Git
- Micromamba
- direnv
- Visual Studio Code

The instructions below describe how to prepare a new Ubuntu computer.

---

## 3. Install the required software

### 3.1 Update Ubuntu

```bash
sudo apt update
sudo apt upgrade
```

Install Git and other basic utilities:

```bash
sudo apt install git curl wget unzip build-essential
```

### 3.2 Install Micromamba

Download and install Micromamba:

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```

Restart the terminal or reload the Bash configuration.

Check the installation:

```bash
micromamba --version
```

Configure the Micromamba root directory:

```bash
micromamba config set root_prefix ~/micromamba
```

Configure the environment directory:

```bash
mkdir -p ~/micromamba/envs
```

Use conda-forge as the package channel:

```bash
micromamba config append channels conda-forge
micromamba config set channel_priority strict
```

Disable automatic activation of the base environment:

```bash
micromamba config set auto_activate_base false
```

Initialize Micromamba for Bash:

```bash
micromamba shell init --shell bash --root-prefix ~/micromamba
```

Restart the terminal.

### 3.3 Install direnv

Install direnv:

```bash
sudo apt install direnv
```

Add the Bash hook to `~/.bashrc`:

```bash
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
```

Add the Micromamba environment directory:

```bash
echo 'export MAMBA_ENVS_DIR="$HOME/micromamba/envs"' >> ~/.bashrc
```

Reload the configuration:

```bash
source ~/.bashrc
```

Verify:

```bash
direnv version
echo "$MAMBA_ENVS_DIR"
```

### 3.4 Install Visual Studio Code

Install Visual Studio Code using the preferred installation method for your Ubuntu system.

Verify that it is available:

```bash
code --version
```

---

## 4. VS Code extensions

Install the following extensions.

### Python development

- Python (`ms-python.python`)
- Pylance (`ms-python.vscode-pylance`)
- Jupyter (`ms-toolsai.jupyter`)
- Ruff (`charliermarsh.ruff`)

### R development

- R (`REditorSupport.r`)

### Remote development (optional)

- Remote - SSH (`ms-vscode-remote.remote-ssh`)

The extensions can be installed through the VS Code Extensions panel.

---

## 5. Create a new project

### 5.1 Create a project from this GitHub template

On GitHub:

1. Open this template repository.
2. Select **Use this template**.
3. Create a new repository for your project.
4. Clone the new repository:

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone <REPOSITORY_URL>
```

Enter the project directory:

```bash
cd <PROJECT_NAME>
```

### 5.2 Create the Micromamba environment

The environment is defined in `environment.yml`.

Create an environment named after the project directory:

```bash
micromamba create -f environment.yml -n "$(basename "$PWD")"
```

This installs Python, R, and the packages specified in the environment definition.

### 5.3 Configure automatic activation

The `.envrc` file contains the project-specific environment activation instructions.

Allow direnv to load it:

```bash
direnv allow
```

Whenever you enter the project directory, direnv automatically activates the corresponding Micromamba environment.

When you leave the directory, the environment is deactivated.

Verify the active environment:

```bash
echo "$CONDA_DEFAULT_ENV"
```

Verify the Python and R executables:

```bash
which python
which R
```

Both should point to the project's Micromamba environment.

---

## 6. Python setup

### 6.1 Select the Python interpreter

Open the project directory in VS Code:

```bash
code .
```

Use the Command Palette:

1. Select **Python: Select Interpreter**.
2. Choose the Python interpreter inside the project environment.

It should be located at:

```text
~/micromamba/envs/<PROJECT_NAME>/bin/python
```

### 6.2 Jupyter Notebook

The environment includes `ipykernel`.

VS Code should be able to discover the Python environment as a Jupyter kernel.

If necessary, register it manually:

```bash
python -m ipykernel install --user \
  --name "$(basename "$PWD")" \
  --display-name "Python ($(basename "$PWD"))"
```

When opening a notebook, select the corresponding Python kernel.

### 6.3 Ruff: linting and formatting

Ruff is used for Python code quality and formatting.

The project settings enable:

- Automatic formatting on save
- Ruff linting
- Ruff formatting
- Ruff quick fixes

You can also run Ruff manually:

```bash
ruff check .
```

Format Python files:

```bash
ruff format .
```

---

## 7. R setup

### 7.1 R interpreter

R is installed inside the project environment.

Verify the installation:

```bash
R --version
```

In VS Code, the R extension should detect the R executable through the activated project environment.

To open an R terminal:

1. Open the Command Palette.
2. Select **R: Create R Terminal**.

Verify the R installation:

```r
R.home()
R.version.string
```

The R home directory should point to the project environment.

### 7.2 R language server

The environment includes `languageserver`.

This provides language support such as:

- Code completion
- Diagnostics
- Navigation
- Hover information

The VS Code R extension uses this package for language-server functionality.

### 7.3 R formatting with Styler

The environment includes `styler`.

You can format an R script manually:

```r
styler::style_file("script.R")
```

### 7.4 R Jupyter kernel

The environment includes `IRkernel`.

Register the R kernel for the current user:

```bash
Rscript -e "IRkernel::installspec(user=TRUE, name='$(basename "$PWD")-r', displayname='R ($(basename "$PWD"))')"
```

After registration, select the corresponding R kernel when opening an R notebook in VS Code.

The kernel registration is user-specific and must be performed separately on each computer.

### 7.5 R graphics configuration

The project includes a `.Rprofile` file.

It configures the graphics device to use a white background in Jupyter:

```r
setHook(
  packageEvent("grDevices", "onLoad"),
  function(...) {
    grDevices::pdf.options(bg = "white")
  }
)
```

This helps avoid black backgrounds in exported or displayed notebook plots.

---

## 8. Daily workflow

### Starting work

Open a terminal and enter the project directory:

```bash
cd ~/Projects/<PROJECT_NAME>
```

The environment should activate automatically.

Open VS Code:

```bash
code .
```

### Python

Create Python scripts:

```text
script.py
```

Create Jupyter notebooks:

```text
notebook.ipynb
```

### R

Create R scripts:

```text
script.R
```

Create R notebooks:

```text
notebook.ipynb
```

Select the appropriate Python or R kernel for each notebook.

### Leaving the project

Simply leave the project directory:

```bash
cd ..
```

direnv automatically deactivates the project environment.

---

## 9. Updating dependencies

The file `environment.yml` is the central record of the project's dependencies.

When adding a package, update this file so the environment can be reproduced on another computer.

For example, add a Python package under the Python dependencies or an R package under the R dependencies.

After modifying the file, update the environment:

```bash
micromamba env update -f environment.yml -n "$(basename "$PWD")"
```

If the environment needs to be recreated from scratch:

```bash
micromamba env remove -n "$(basename "$PWD")"
micromamba create -f environment.yml -n "$(basename "$PWD")"
```

After recreating the environment, register the R Jupyter kernel again:

```bash
Rscript -e "IRkernel::installspec(user=TRUE, name='$(basename "$PWD")-r', displayname='R ($(basename "$PWD"))')"
```

---

## 10. Git and version control

The project uses Git for version control.

The `.gitignore` file excludes temporary files and local development artifacts, including:

- Python cache files
- Ruff cache
- R history and workspace files
- Jupyter checkpoints
- Operating-system metadata

The environment itself is not stored in Git. Instead, `environment.yml` records the dependencies needed to recreate it.

Commit changes to the project configuration whenever dependencies or shared settings are modified.

---

## 11. Troubleshooting

### Environment does not activate

Run:

```bash
direnv allow
```

Check that the `.envrc` file exists and that direnv is initialized in Bash.

### Python or R points to the system installation

Check:

```bash
echo "$CONDA_DEFAULT_ENV"
which python
which R
```

If necessary, leave the project directory and enter it again.

### VS Code does not detect Python

Use **Python: Select Interpreter** and manually select:

```text
~/micromamba/envs/<PROJECT_NAME>/bin/python
```

### VS Code does not detect R

Verify that the environment is active and that R is available:

```bash
which R
R --version
```

Then reload the VS Code window.

### R kernel is missing

Register it again:

```bash
Rscript -e "IRkernel::installspec(user=TRUE, name='$(basename "$PWD")-r', displayname='R ($(basename "$PWD"))')"
```

### Dependencies are missing

Update the environment:

```bash
micromamba env update -f environment.yml -n "$(basename "$PWD")"
```

---

## 12. Project structure

A typical project created from this template has the following structure:

```text
PROJECT_NAME/
│
├── .git/
├── .vscode/
│   └── settings.json
│
├── .envrc
├── .gitignore
├── .Rprofile
├── environment.yml
├── README.md
│
├── data/
├── notebooks/
├── scripts/
└── results/
```

The `data`, `notebooks`, `scripts`, and `results` directories can be created as needed.

---

## 13. Reproducibility

To reproduce the project on another Ubuntu computer:

1. Install Git, Micromamba, direnv, and VS Code.
2. Configure Bash as described above.
3. Clone the project repository.
4. Create the environment using `environment.yml`.
5. Run `direnv allow`.
6. Open the project in VS Code.
7. Register the R Jupyter kernel.
8. Select the appropriate Python or R interpreter and notebook kernel.

This recreates the project's software environment without requiring a copy of the original computer's installed packages.