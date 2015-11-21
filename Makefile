#
# HMCSIM TOP-LEVEL MAKEFILE
# GOBLIN-CORE 64
#

include Makefile.inc

PKGS := ...
LIBNAME := hmcsim
SRCDIR := src
BUILDDIR := build
LIBS :=
TARGET := lib$(LIBNAME).a
LDFLAGS :=
ARFLAGS := rcs

.PHONY : test tools cmc

SRCEXT = c
SOURCES := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))
DEPS := $(OBJECTS:.o=.deps)

$(TARGET): $(OBJECTS)
	@echo " Linking..."; $(AR) $(AR_OPTS) $(TARGET) $(OBJECTS)
	@echo " Building CMC Libs..."; make -C ./cmc/

$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(BUILDDIR)
	@echo " CC $<"; $(CC) $(CFLAGS) -MD -MF $(@:.o=.deps) -c -o $@ $<

docs:
	@echo " Building Docs..."; $(DOXYGEN) ./doxygen/hmc_sim.cfg
doclean:
	@echo " Cleaning Docs..."; $(RM) -Rf ./doxygen/{html,latex,man,rtf,xml}
clean: doclean
	@echo " Cleaning..."; $(RM) -r $(BUILDDIR) $(TARGET)
test: $(TARGET)
	@echo " Building Tests..."; make -C ./test/
cmc:
	@echo " Building CMC Libs..."; make -C ./cmc/
tools:
	@echo " Building Tools..."; make -C ./tools/
cmcclean:
	@echo " Cleaning CMC..."; make -C ./cmc/ clean
toolsclean:
	@echo " Cleaning Tools..."; make -C ./tools/ clean
testclean:
	@echo " Cleaning Tests..."; make -C ./test/ clean
distclean: clean testclean doclean toolsclean cmcclean

-include $(DEPS)

.PHONY: clean
