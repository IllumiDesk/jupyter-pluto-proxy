FROM jupyter/datascience-notebook:latest

USER "${NB_USER}"

RUN mkdir "${HOME}/app"

WORKDIR "${HOME}/app"

RUN julia -e 'using Pkg; Pkg.update(); \
    Pkg.add(PackageSpec.(["CSV", "Images", "Plots", "Pluto", "Statistics"]))'

COPY . "${HOME}/app"

RUN python3 -m pip install -U pip \
 && python3 -m pip install -e .

USER root

# update permissions as root
RUN fix-permissions /etc/jupyter/ \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "${JULIA_PKGDIR}" \
 && fix-permissions "${HOME}"

USER "${NB_UID}"

WORKDIR "${HOME}"
