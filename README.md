# Python and R Project Template

A reusable project template for bioinformatics and data analysis using Python and R.

The project environment is managed with **Micromamba**, activated automatically with **direnv**, and configured for **Visual Studio Code**.

## 1. Starting a new project

### Create a repository

1. Open the GitHub template repository.
2. Select **Use this template → Create a new repository**.
3. Give your new repository a project-specific name.
4. Clone the new repository:

```bash
git clone git@github.com:YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### Create the project environment

From the project directory:

```bash
micromamba create -f environment.yml -n "$(basename "$PWD")"
```

This creates an environment named after the project directory.

### Activate the environment

Allow direnv to activate the environment automatically:

```bash
direnv allow
```

The environment should now activate whenever you enter the project directory and deactivate when you leave it.

Verify that Python and R come from the project environment:

```bash
which python
which R
```

Both should point to the project's Micromamba environment.

### Open the project in VS Code

```bash
code .
```

VS Code should use the Python interpreter from the active project environment.

---

## 2. Working with Python

### Python scripts

Create Python scripts in the project directory or in a dedicated source directory.

Run a script with:

```bash
python script.py
```

### Jupyter notebooks

Create or open a notebook (`.ipynb`) in VS Code.

Select the Python kernel belonging to the project environment.

If the kernel is not listed, register it:

```bash
python -m ipykernel install --user \
    --name "$(basename "$PWD")" \
    --display-name "Python ($(basename "$PWD"))"
```

### Code formatting and linting

This template uses Ruff for Python formatting and linting.

The VS Code settings enable formatting on save and Ruff linting.

You can also run Ruff manually:

```bash
ruff check .
ruff format .
```

---

## 3. Working with R

### R scripts

Run an R script with:

```bash
Rscript script.R
```

Or open an R terminal in VS Code using the R extension.

The R extension should automatically find the R installation in the active Micromamba environment.

### Project-specific R package library

R packages installed through the project setup script are stored in:

```text
.R/library/
```

This library is configured automatically through `R_LIBS_USER` in `.envrc`.

It keeps project-specific R packages separate from the system and Micromamba libraries.

The `.R/library/` directory is excluded from Git.

### Installing Bioconductor packages

The project includes:

```text
scripts/install-bloc.R
```

This script installs the project's selected Bioconductor packages using BiocManager.

Run it from the project root:

```bash
Rscript scripts/install-bloc.R
```

The script installs packages into the project-specific R library.

If you add or remove Bioconductor packages, edit this script accordingly.

### R Jupyter kernel

To use R in Jupyter notebooks, register the IRkernel:

```bash
Rscript -e 'IRkernel::installspec(
    user = TRUE,
    name = "project-r",
    displayname = "R (project)"
)'
```

This registration is user-specific and normally only needs to be done once per computer for each desired kernel.

### R plotting

The project includes an `.Rprofile` that configures a white background for PDF graphics devices. This helps avoid black backgrounds in some Jupyter plotting situations.

---

## 4. Managing dependencies

In general:

- Use `environment.yml` for Python packages, command-line tools, native libraries, and R packages available through Conda channels.
- Use `scripts/install-bloc.R` for Bioconductor packages installed through BiocManager.

### Python and system dependencies

Edit `environment.yml` to add or remove Python packages, R packages available through conda-forge/Bioconda, and command-line tools.

For example, Samtools is installed as a command-line program through Bioconda.

After changing `environment.yml`, update the existing environment:

```bash
micromamba env update -f environment.yml -n "$(basename "$PWD")"
```

### Bioconductor dependencies

Edit `scripts/install-bloc.R` to change the Bioconductor packages installed for the project.

Then run:

```bash
Rscript scripts/install-bloc.R
```

### Bioinformatics command-line tools

The project environment includes several sequencing tools installed through Bioconda:

| Tool | Purpose |
|---|---|
| Samtools | Manipulation and analysis of SAM/BAM/CRAM files |
| Bowtie2 | Short-read alignment |
| HISAT2 | Splice-aware RNA-seq alignment |
| Subread / featureCounts | Gene-level read quantification |

These tools are installed automatically when creating the Micromamba environment from `environment.yml`.

To check their availability:

```bash
samtools --version
bowtie2 --version
hisat2 --version
```

HISAT2 is used instead of the older TopHat2, which has been superseded by HISAT2.

Additional command-line tools can be added to `environment.yml` as needed.

### Important

Do not commit installed environments or the project R library.

Commit the dependency definitions and installation scripts instead, so the environment can be recreated on another computer.

---

## 5. Git workflow

Check the changes:

```bash
git status
```

Stage and commit:

```bash
git add -A
git commit -m "Describe your changes"
```

Push to GitHub:

```bash
git push
```

The repository should contain the project files, configuration, and dependency definitions, but not installed packages, temporary files, or generated data that should remain local.

---

# Setting up a new computer

This section is intended for initial computer setup. It normally only needs to be completed once per computer.

The instructions below assume Ubuntu and Bash.

## 6. Install Git

Install Git:

```bash
sudo apt update
sudo apt install git
```

Configure your identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "YOUR_EMAIL"
```

## 7. Install Micromamba

Install Micromamba following its official installation instructions.

Make sure it is available at:

```text
~/.local/bin/micromamba
```

Configure the Micromamba root directory:

```bash
micromamba config set root_prefix ~/micromamba
```

Configure channels:

```bash
micromamba config prepend channels conda-forge
micromamba config prepend channels bioconda
micromamba config set channel_priority strict
```

Initialize Micromamba for Bash:

```bash
micromamba shell init -s bash -r ~/micromamba
```

Add the following to `~/.bashrc` if it is not already present:

```bash
export MAMBA_ENVS_DIR="$HOME/micromamba/envs"
```

Restart the terminal or reload the configuration:

```bash
source ~/.bashrc
```

## 8. Install direnv

Install direnv:

```bash
sudo apt install direnv
```

Add the following to `~/.bashrc`:

```bash
eval "$(direnv hook bash)"
```

Reload Bash:

```bash
source ~/.bashrc
```

## 9. Install Visual Studio Code

Install Visual Studio Code using the official installation instructions.

Install these extensions:

- Python (`ms-python.python`)
- Pylance (`ms-python.vscode-pylance`)
- Jupyter (`ms-toolsai.jupyter`)
- Ruff (`charliermarsh.ruff`)
- R (`REditorSupport.r`)

Additional extensions can be installed as needed.

## 10. Configure GitHub SSH access

Generate an SSH key:

```bash
ssh-keygen -t ed25519 -C "YOUR_EMAIL"
```

Start the SSH agent and add the key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Display the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add the public key to your GitHub account under **Settings → SSH and GPG keys**.

Test the connection:

```bash
ssh -T git@github.com
```

A successful authentication message confirms that SSH access is configured.

---

## 11. Creating additional projects

Once the computer prerequisites are installed, creating another project is straightforward:

1. Create a repository from this GitHub template.
2. Clone the repository.
3. Create the Micromamba environment from `environment.yml`.
4. Run `direnv allow`.
5. Open the project in VS Code.
6. Install the project's Bioconductor packages using `scripts/install-bloc.R`.
7. Register the R Jupyter kernel if needed.