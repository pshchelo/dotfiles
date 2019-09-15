gs  \
    -dNOPAUSE \
    -dBATCH \
    -sDEVICE=pdfwrite \
    -sColorConversionStrategy=Gray \
    -dProcessColorModel=/DeviceGray \
    -dCompatibilityLevel=1.4 \
    -dAutoRotatePages=/None \
    -sOutputFile=greyscale.pdf \
    "$@"
