
# Makefile to build Trick

# Make Targets
#-------------------------------------------------------------------------------
# default   - Compile Trick-core and Trick Data-products Libraries and Applications.
# 'no_dp'   - Compile Trick-core only.
# 'dp'      - Compile Data-products only.
# 'java'    - Compile Java GUI Applications
# 'javadoc' - Generate Java Documentation.
# 'doxygen' - Generate HTML User's Guide.
# 'test'    - Run Unit-tests and Simulation Tests.

export TRICK_HOME = $(CURDIR)

# Include the build configuration information.
include $(TRICK_HOME)/share/trick/makefiles/Makefile.common

#-------------------------------------------------------------------------------
# Specify the contents of: libtrick.a
#-------------------------------------------------------------------------------
TRICK_LIB = $(TRICK_LIB_DIR)/libtrick.a
SIM_SERV_DIRS = \
	${TRICK_HOME}/trick_source/sim_services/ExternalApplications \
	${TRICK_HOME}/trick_source/sim_services/Clock \
	${TRICK_HOME}/trick_source/sim_services/CheckPointAgent \
	${TRICK_HOME}/trick_source/sim_services/CheckPointRestart \
	${TRICK_HOME}/trick_source/sim_services/Collect \
	${TRICK_HOME}/trick_source/sim_services/CommandLineArguments \
	${TRICK_HOME}/trick_source/sim_services/DataRecord \
	${TRICK_HOME}/trick_source/sim_services/DebugPause \
	${TRICK_HOME}/trick_source/sim_services/DMTCP \
	${TRICK_HOME}/trick_source/sim_services/EchoJobs \
	${TRICK_HOME}/trick_source/sim_services/Environment \
	${TRICK_HOME}/trick_source/sim_services/EventManager \
	${TRICK_HOME}/trick_source/sim_services/Executive \
	${TRICK_HOME}/trick_source/sim_services/FrameLog \
	${TRICK_HOME}/trick_source/sim_services/JITInputFile \
	${TRICK_HOME}/trick_source/sim_services/JSONVariableServer \
	${TRICK_HOME}/trick_source/sim_services/Integrator \
	${TRICK_HOME}/trick_source/sim_services/UnitTest \
	${TRICK_HOME}/trick_source/sim_services/MasterSlave \
	${TRICK_HOME}/trick_source/sim_services/MemoryManager \
	${TRICK_HOME}/trick_source/sim_services/Message \
	${TRICK_HOME}/trick_source/sim_services/MonteCarlo \
	${TRICK_HOME}/trick_source/sim_services/RealtimeInjector \
	${TRICK_HOME}/trick_source/sim_services/RealtimeSync \
	${TRICK_HOME}/trick_source/sim_services/STL \
	${TRICK_HOME}/trick_source/sim_services/ScheduledJobQueue \
	${TRICK_HOME}/trick_source/sim_services/Scheduler \
	${TRICK_HOME}/trick_source/sim_services/Sie \
	${TRICK_HOME}/trick_source/sim_services/SimObject \
	${TRICK_HOME}/trick_source/sim_services/SimTime \
	${TRICK_HOME}/trick_source/sim_services/ThreadBase \
	${TRICK_HOME}/trick_source/sim_services/Timer \
	${TRICK_HOME}/trick_source/sim_services/Units \
	${TRICK_HOME}/trick_source/sim_services/VariableServer \
	${TRICK_HOME}/trick_source/sim_services/Zeroconf \
	${TRICK_HOME}/trick_source/sim_services/include \
	${TRICK_HOME}/trick_source/sim_services/mains

SIM_SERV_OBJS = $(addsuffix /object_$(TRICK_HOST_CPU)/*.o ,$(SIM_SERV_DIRS))
SIM_SERV_OBJS := $(filter-out ${TRICK_HOME}/trick_source/sim_services/MemoryManager/%, $(SIM_SERV_OBJS))

ER7_UTILS_DIRS = \
	${ER7_UTILS_HOME}/CheckpointHelper \
	${ER7_UTILS_HOME}/integration/abm4 \
	${ER7_UTILS_HOME}/integration/beeman \
	${ER7_UTILS_HOME}/integration/core \
	${ER7_UTILS_HOME}/integration/euler \
	${ER7_UTILS_HOME}/integration/mm4 \
	${ER7_UTILS_HOME}/integration/nl2 \
	${ER7_UTILS_HOME}/integration/position_verlet \
	${ER7_UTILS_HOME}/integration/rk2_heun \
	${ER7_UTILS_HOME}/integration/rk2_midpoint \
	${ER7_UTILS_HOME}/integration/rk4 \
	${ER7_UTILS_HOME}/integration/rkf45 \
	${ER7_UTILS_HOME}/integration/rkf78 \
	${ER7_UTILS_HOME}/integration/rkg4 \
	${ER7_UTILS_HOME}/integration/symplectic_euler \
	${ER7_UTILS_HOME}/integration/velocity_verlet \
	${ER7_UTILS_HOME}/interface \
	${ER7_UTILS_HOME}/math \
	${ER7_UTILS_HOME}/trick/integration
ER7_UTILS_OBJS = $(addsuffix /object_$(TRICK_HOST_CPU)/*.o ,$(ER7_UTILS_DIRS))

UTILS_DIRS := \
	${TRICK_HOME}/trick_source/trick_utils/interpolator \
	${TRICK_HOME}/trick_source/trick_utils/trick_adt \
	${TRICK_HOME}/trick_source/trick_utils/comm \
	${TRICK_HOME}/trick_source/trick_utils/shm \
	${TRICK_HOME}/trick_source/trick_utils/math \
	${TRICK_HOME}/trick_source/trick_utils/units
UTILS_OBJS := $(addsuffix /object_$(TRICK_HOST_CPU)/*.o ,$(UTILS_DIRS))

# filter out the directories that make their own libraries
UTILS_OBJS := $(filter-out ${TRICK_HOME}/trick_source/trick_utils/comm/%, $(UTILS_OBJS))
UTILS_OBJS := $(filter-out ${TRICK_HOME}/trick_source/trick_utils/math/%, $(UTILS_OBJS))
UTILS_OBJS := $(filter-out ${TRICK_HOME}/trick_source/trick_utils/units/%, $(UTILS_OBJS))

#-------------------------------------------------------------------------------
# Specify the contents of: libtrick_pyip.a
# This library contains the SWIG generated interface-code between Trick and Python.
#-------------------------------------------------------------------------------
TRICK_SWIG_LIB = $(TRICK_LIB_DIR)/libtrick_pyip.a

SWIG_DIRS = \
	${TRICK_HOME}/trick_source/sim_services/InputProcessor \
	${TRICK_HOME}/trick_source/trick_swig

SWIG_OBJS = $(addsuffix /object_$(TRICK_HOST_CPU)/*.o ,$(SWIG_DIRS))

#-------------------------------------------------------------------------------
# Specify where to find units tests.
#-------------------------------------------------------------------------------
UNIT_TEST_DIRS := \
    $(wildcard ${TRICK_HOME}/trick_source/sim_services/*/test) \
    $(wildcard ${TRICK_HOME}/trick_source/trick_utils/*/test) \
    ${TRICK_HOME}/trick_source/data_products/DPX/test/unit_test
ifeq ($(USE_ER7_UTILS_INTEGRATORS), 0)
  UNIT_TEST_DIRS := $(filter-out %Integrator/test,$(UNIT_TEST_DIRS))
endif

#-------------------------------------------------------------------------------
# FIXME:
# This is only used by the 'clean_test' target below. Seems to me that it really
# doesn't belong here. Instead, the 'clean' target in
# $TRICK_HOME/trick_sims/makefile define this.
#-------------------------------------------------------------------------------
MODEL_DIRS = \
	${TRICK_HOME}/trick_models/Ball++/L1 \
	${TRICK_HOME}/trick_models/ball/L1 \
	${TRICK_HOME}/trick_models/ball/L2 \
	${TRICK_HOME}/trick_models/baseball/aero \
	${TRICK_HOME}/trick_models/baseball/optim \
	${TRICK_HOME}/trick_models/cannon/aero \
	${TRICK_HOME}/trick_models/cannon/graphics \
	${TRICK_HOME}/trick_models/cannon/gravity \
	${TRICK_HOME}/trick_models/cannon/optim \
	${TRICK_HOME}/trick_models/exclude_me \
	${TRICK_HOME}/trick_models/helios \
	${TRICK_HOME}/trick_models/stl_checkpoint \
	${TRICK_HOME}/trick_models/target \
	${TRICK_HOME}/trick_models/test/dp \
	${TRICK_HOME}/trick_models/test/impexp \
	${TRICK_HOME}/trick_models/test/ip \
	${TRICK_HOME}/trick_models/test/ip2 \
	${TRICK_HOME}/trick_models/test/sched \
	${TRICK_HOME}/trick_models/test_ip \
	${TRICK_HOME}/trick_models/threads

# The name of the ICG executable indicates the operating system, and the machine
# hardware on which it is built. This allows pre-build ICG binaries to be
# distributed in the installation package. The reason for distributing pre-built
# ICG binaries is because the user's machine may not have the requisite clang
# libraries.
ICG_EXE := ${TRICK_HOME}/bin/trick-ICG

################################################################################
#                                   RULES
################################################################################
# DEFAULT TARGET
# 1 Build Trick-core and Trick Data-products.
all: no_dp dp java
	@ echo ; echo "[32mTrick compilation complete:[00m" ; date

#-------------------------------------------------------------------------------
# 1.1 Build Trick-core
no_dp: $(TRICK_LIB) $(TRICK_SWIG_LIB)
	@ echo ; echo "Trick libs compiled:" ; date

# 1.1.1 Build libTrick.a
$(TRICK_LIB): $(SIM_SERV_DIRS) $(UTILS_DIRS) | $(TRICK_LIB_DIR)
	ar crs $@ $(SIM_SERV_OBJS) $(UTILS_OBJS)

ifeq ($(USE_ER7_UTILS_INTEGRATORS), 1)
ER7_UTILS_LIB = $(TRICK_LIB_DIR)/liber7_utils.a
no_dp: $(ER7_UTILS_LIB)

$(ER7_UTILS_LIB): $(ER7_UTILS_DIRS) | $(TRICK_LIB_DIR)
	ar crs $@ $(ER7_UTILS_OBJS)
endif

# 1.1.1.1 Compile the objects in the specified sim_services directories.
.PHONY: $(SIM_SERV_DIRS)
$(SIM_SERV_DIRS): icg_sim_serv $(TRICK_LIB_DIR)
	@ $(MAKE) -C $@ trick

# 1.1.1.2 Compile the objects in the specified utils directories.
.PHONY: $(UTILS_DIRS)
$(UTILS_DIRS): icg_sim_serv
	@ $(MAKE) -C $@ trick

# 1.1.1.3 Compile the objects in the specified er7_utils directories.
.PHONY: $(ER7_UTILS_DIRS)
$(ER7_UTILS_DIRS): TRICK_CXXFLAGS += -Wno-unused-parameter
$(ER7_UTILS_DIRS): make_er7_makefiles icg_sim_serv
	@ $(MAKE) -C $@ trick

.PHONY: make_er7_makefiles
make_er7_makefiles:
	@for i in $(ER7_UTILS_DIRS) ; do \
	   $(CP) ${TRICK_HOME}/trick_source/sim_services/Executive/Makefile $$i; \
	done

ifeq ($(USE_ER7_UTILS_INTEGRATORS), 1)
icg_sim_serv: | make_er7_makefiles
endif

# 1.1.1.4 Generate interface code (using ICG) for the specified sim_services
# header files.
.PHONY: icg_sim_serv
icg_sim_serv: $(ICG_EXE)
	${TRICK_HOME}/bin/trick-ICG -s -m ${TRICK_CXXFLAGS} ${TRICK_SYSTEM_CXXFLAGS} ${TRICK_HOME}/include/trick/files_to_ICG.hh

# 1.1.1.4.1 Build the Interface Code Generator (ICG) executable.
$(ICG_EXE) :
	$(MAKE) -C trick_source/codegen/Interface_Code_Gen

# 1.1.1.5 Create Trick Library directory.
$(TRICK_LIB_DIR):
	@ mkdir $@

# 1.1.2 Build libTrick_pyip.a (Swig Lib)
$(TRICK_SWIG_LIB): $(SWIG_DIRS) | $(TRICK_LIB_DIR)
	ar crs $@ $(SWIG_OBJS)

.PHONY: $(SWIG_DIRS)
$(SWIG_DIRS): icg_sim_serv $(TRICK_LIB_DIR)
	@ $(MAKE) -C $@ trick

#-------------------------------------------------------------------------------
# 1.2 Build Trick's Data-products Applications.
.PHONY: dp
dp: ${TRICK_HOME}/trick_source/trick_utils/units
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/data_products

#-------------------------------------------------------------------------------
# 1.3 Build Trick's Java Tools
java:
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/java

.PHONY: javadoc
javadoc:
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/java $@

#-------------------------------------------------------------------------------
# 1.4 This target builds the Trick Documentation.
.PHONY: doxygen
doxygen:
	@ $(MAKE) -C $@

#-------------------------------------------------------------------------------
# 1.5 Some Trick source is auto-generated as part of the Trick's build process. When
# Trick is distributed to the user community, we can't be certain that everyone's
# machine will have the approriate versions of the code generations tool. So rather
# than just hope, we go ahead and pre-generate the necessary source files, and
# include those in the distribution package.
# This target pre-generates these source files, that are necessary for creating
# a distribution package.
premade:
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/sim_services/MemoryManager premade
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/sim_services/CheckPointAgent premade
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/java

################################################################################
#                                   TESTING
################################################################################
# This target runs Trick's Unit-tests and simulation-tests.
test: unit_test sim_test
	@ echo "All tests completed sucessfully"

.PHONY: $(UNIT_TEST_DIRS)
$(UNIT_TEST_DIRS):
	@ $(MAKE) -C $@ test

unit_test: $(UNIT_TEST_DIRS)

sim_test:
	@ $(MAKE) -C trick_sims test

#requirements:
#	@ $(MAKE) -C trick_test/requirements_docs install

################################################################################
#                                 CLEAN Targets
################################################################################


clean: clean_sim_serv clean_utils clean_swig clean_dp clean_ICG clean_java
	@/bin/rm -rf $(TRICK_BIN_DIR)
	@/bin/rm -rf $(TRICK_LIB_DIR)

ifeq ($(USE_ER7_UTILS_INTEGRATORS), 1)
clean: clean_er7_utils
endif

clean_sim_serv:
	@for i in $(SIM_SERV_DIRS) ; do \
	   $(MAKE) -C $$i real_clean ; \
	done
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/sim_services/mains real_clean

clean_er7_utils: make_er7_makefiles
	@for i in $(ER7_UTILS_DIRS) ; do \
	   $(MAKE) -C $$i real_clean ; \
	   rm $$i/Makefile; \
	done

clean_utils:
	@for i in $(UTILS_DIRS) ; do \
	   $(MAKE) -C $$i real_clean ; \
	done

clean_swig:
	@for i in $(SWIG_DIRS) ; do \
	   $(MAKE) -C $$i real_clean ; \
	done

ifeq ($(USE_ER7_UTILS_INTEGRATORS), 1)
clean_swig: make_er7_makefiles
endif

clean_ICG :
	$(MAKE) -C ${TRICK_HOME}/trick_source/codegen/Interface_Code_Gen  clean

clean_unit_test:
	@/bin/rm -rf ${TRICK_HOME}/trick_test/*.xml
	@ for i in $(UNIT_TEST_DIRS) ; do \
	    $(MAKE) -C $$i clean ; \
	done

clean_doxygen:
	@ $(MAKE) -C ${TRICK_HOME}/doxygen clean


clean_dp:
	@ $(MAKE) clean -C ${TRICK_HOME}/trick_source/data_products

clean_java:
	@ $(MAKE) -C ${TRICK_HOME}/trick_source/java clean


# FIXME: Seems to me that the for loop below should be removed and that the
#        'clean' target in trick_sims/makefile should be doing this. --Penn
clean_test: clean_unit_test
	-@ $(MAKE) -C trick_sims clean
	@for i in $(MODEL_DIRS) ; do \
	   cd $$i ; /bin/rm -rf io_src object_* swig xml ; \
	done

clean_gui: clean_java

################################################################################
#                                 INSTALL Targets
################################################################################

install:
	cp -r bin include $(notdir ${TRICK_LIB_DIR}) libexec share ${PREFIX}

uninstall:
	rm -f ${PREFIX}/bin/trick-*
	rm -rf ${PREFIX}/include/trick
	rm -f ${PREFIX}/${BASE_LIB_DIR}/libtrick*
	rm -rf ${PREFIX}/libexec/trick
	rm -rf ${PREFIX}/share/doc/trick
	rm -f ${PREFIX}/share/man/man1/trick-*
	rm -rf ${PREFIX}/share/trick

###########

# These rules run the alternatives command in linux to create links in /usr/local/bin for Trick.
#ifeq ($(TRICK_HOST_TYPE),Linux)
#ALTERNATIVES := $(shell which alternatives || which update-alternatives)
#
#install: set_alternatives
#.PHONY: set_alternatives
#set_alternatives: copy_files
#	- ${ALTERNATIVES} --install /usr/local/bin/CP trick ${PREFIX}/trick/trick-$(TRICK_VERSION)/bin/trick-CP 10 \
#  --slave /usr/local/bin/trick-ICG trick-ICG /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-ICG \
#  --slave /usr/local/bin/trick-gte trick-gte /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-gte \
#  --slave /usr/local/bin/trick-killsim trick-killsim /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-killsim \
#  --slave /usr/local/bin/trick-sie trick-sie /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-sie \
#  --slave /usr/local/bin/trick-sim_control trick-simcontrol /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-simcontrol \
#  --slave /usr/local/bin/trick-sniffer trick-sniffer /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-sniffer \
#  --slave /usr/local/bin/trick-dp trick-dp /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-dp \
#  --slave /usr/local/bin/trick-version trick-version /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-version \
#  --slave /usr/local/bin/trick-tv trick-tv /usr/local/trick/trick-$(TRICK_VERSION)/bin/trick-tv
#
#uninstall: remove_alternatives
#.PHONY: remove_alternatives
#remove_alternatives:
#	- ${ALTERNATIVES} --remove trick ${PREFIX}/trick/trick-$(TRICK_VERSION)/bin/CP
#endif

################################################################################
#                    MISCELLANEOUS DEVELOPER UTILITY TARGETS                   #
################################################################################
# ICG all sim_services files (for testing and debugging ICG).
# The -f flag forces io_src files to be regenerated whether or not they need to be.
ICG: $(ICG_EXE)
	${TRICK_HOME}/bin/trick-ICG -f -s -m ${TRICK_CXXFLAGS} ${TRICK_SYSTEM_CXXFLAGS} ${TRICK_HOME}/include/trick/files_to_ICG.hh

# This builds a tricklib share library.
ifeq ($(USE_ER7_UTILS_INTEGRATORS), 1)
trick_lib: $(SIM_SERV_DIRS) $(ER7_UTILS_DIRS) $(UTILS_DIRS) | $(TRICK_LIB_DIR)
	${TRICK_CPPC} $(SHARED_LIB_OPT) -o ${TRICK_LIB_DIR}/libtrick.so $(SIM_SERV_OBJS) $(ER7_UTILS_OBJS) $(UTILS_OBJS)
else
trick_lib: $(SIM_SERV_DIRS) $(UTILS_DIRS) | $(TRICK_LIB_DIR)
	${TRICK_CPPC} $(SHARED_LIB_OPT) -o ${TRICK_LIB_DIR}/libtrick.so $(SIM_SERV_OBJS) $(UTILS_OBJS)
endif

# For NASA/JSC developers include optional rules
-include Makefile_jsc_dirs


tweak  this
