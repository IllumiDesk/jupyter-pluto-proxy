FROM jupyter/datascience-notebook:latest

USER "${NB_USER}"

RUN mkdir "${HOME}/app"

WORKDIR "${HOME}/app"

COPY . "${HOME}/app"

RUN python3 -m pip install -U pip \
 && python3 -m pip install -e .

RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("CSV")' && \
    julia -e 'import Pkg; Pkg.add("Images")' && \
    julia -e 'import Pkg; Pkg.add("Plots")' && \
    julia -e 'import Pkg; Pkg.add("Pluto")' && \
    julia -e 'import Pkg; Pkg.add("Statistics")'

USER root

# update permissions as root
RUN fix-permissions /etc/jupyter/ \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "${JULIA_PKGDIR}" \
 && fix-permissions "${HOME}"

USER "${NB_UID}"

WORKDIR "${HOME}"
