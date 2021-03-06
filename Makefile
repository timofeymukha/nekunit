SRCS := $(NEK_SOURCE_ROOT)/core/speclib.f
OBJS := $(SRCS:%.f=%.o)

all: my_tests

libsut.a: $(OBJS)
	$(AR) -r $@ $?

ifeq (nagfor,$(findstring nagfor,$(FC)))
  FFLAGS += -fpp
endif

%.o : %.F90
	$(FC) -c $(FFLAGS) $<


LATEST_PFUNIT_DIR := $(PFUNIT_DIR)/PFUNIT-4.2
include $(LATEST_PFUNIT_DIR)/include/PFUNIT.mk

FFLAGS += $(PFUNIT_EXTRA_FFLAGS)

#test_square.o: square.mod
#square.mod: square.o

my_tests: libsut.a

my_tests_TESTS := test_speclib.pf
my_tests_REGISTRY :=
my_tests_OTHER_SOURCES :=
my_tests_OTHER_LIBRARIES := -L. -lsut
my_tests_OTHER_INCS :=

$(eval $(call make_pfunit_test,my_tests))


clean:
	$(RM) *.o *.mod *.a *.inc test_square.F90 my_tests
