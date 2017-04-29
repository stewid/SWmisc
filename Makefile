# Determine package name and version from DESCRIPTION file
PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

# Name of built package
PKG_TAR=$(PKG_NAME)_$(PKG_VERSION).tar.gz

# Install package
install:
	cd .. && R CMD INSTALL $(PKG_NAME)

# Build documentation with roxygen
# 1) Remove old doc
# 2) Generate documentation
roxygen:
	rm -f man/*.Rd
	Rscript -e "library(devtools); devtools::document()"

# Build and check package
check:
	cd .. && R CMD build $(PKG_NAME)
	cd .. && _R_CHECK_CRAN_INCOMING_=FALSE R CMD check --as-cran $(PKG_TAR)

.PHONY: install roxygen check
