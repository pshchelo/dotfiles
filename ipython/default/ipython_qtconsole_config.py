# Configuration file for ipython-qtconsole.

c = get_config()

c.IPythonWidget.gui_completion = 'droplist'
c.IPythonWidget.editor = 'gvim {filename}'
c.IPythonWidget.syntax_style = c.IPythonWidget.syntax_style = u'solarizedlight'
c.IPythonWidget.font_family = u'Anonymous Pro'
c.IPythonWidget.font_size = 11
c.IPythonWidget.editor_line = u'gvim +{line} {filename}'
c.IPythonWidget.paging = 'vsplit'
c.InlineBackend.figure_formats = set(['svg', 'png'])
