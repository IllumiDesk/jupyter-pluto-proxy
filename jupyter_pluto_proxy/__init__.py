import os
import shutil
import logging


logger = logging.getLogger(__name__)
logger.setLevel('INFO')


def setup_pluto():
    """Setup commands and icon paths and return a dictionary compatible
    with jupyter-server-proxy.
    """
    def _get_icon_path():
        return os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'icons', 'pluto.svg'
    )

    # Make sure executable is in $PATH
    def _get_pluto_command(port):
        # Create pluto working directory
        home_dir = os.environ.get('HOME') or '/home/jovyan'
        working_dir = f'{home_dir}/pluto'
        if not os.path.exists(working_dir):
            os.makedirs(working_dir)
            logger.info("Created directory %s" % working_dir)
        else:    
            logger.info("Directory %s already exists" % working_dir)
        return ["julia", "-e", "import Pkg; Pkg.add(Pkg.PackageSpec(;name=\"Pluto\", rev=\"c3e4b0f8a\")); import Pluto; Pluto.run(\"0.0.0.0\", " + str(port) + ")"]
    
    return {
        'command': '_get_pluto_command',
        'timeout': 20,
        'new_browser_tab': True,
        'launcher_entry': {
            'title': 'Pluto Notebook',
            'icon_path': _get_icon_path()
        },
    }
