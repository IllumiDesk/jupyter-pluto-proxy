import os
import shutil
import logging

from typing import Any
from typing import Dict


logger = logging.getLogger(__name__)
logger.setLevel('INFO')


def setup_pluto() -> Dict[str, Any]:
    """Setup commands and icon paths and return a dictionary compatible
    with jupyter-server-proxy.
    """
    def _get_icon_path():
        return os.path.join(
            os.path.dirname(os.path.abspath(__file__)), 'icons', 'pluto.svg'
    )

    return {
        "command": ["julia", "--optimize=0", "-e", "import Pluto; Pluto.run(host=\"0.0.0.0\", port={port}, launch_browser=false, require_secret_for_open_links=false, require_secret_for_access=false)"],
        'timeout': 20,
        'new_browser_tab': True,
        'launcher_entry': {
            'title': 'Pluto Notebook',
            'icon_path': _get_icon_path()
        },
    }
