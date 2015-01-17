# Configuration file for ipython-notebook.

c = get_config()

c.NotebookApp.notebook_dir = u'/home/pshchelo/devel/ipynb'
c.FileNotebookManager.notebook_dir = u'/home/pshchelo/devel/ipynb'
c.InlineBackend.figure_formats = set(['svg', 'png'])
