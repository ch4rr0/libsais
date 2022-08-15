PROJECTS=libsais libsais64
PLIBNAME=libsais
PVER=2.7.0
PSOVER=2
ifeq ($(OS),Windows_NT)
  PLIBSTATIC=$(PLIBNAME).a
#  PLIBSHARED=$(PROJECT)-$(PVER).dll
else
  PLIBSTATIC=$(PLIBNAME).a
#  PLIBSHARED=$(PLIBNAME).so.$(PSOVER)
endif
PLIBS=$(PLIBSTATIC)
CC=gcc
CFLAGS?=-Wall -O2
LDFLAGS?=-lm
AR?=ar
INSTALL?=install
RM?=rm -f
RMD?=$(RM) -r
PREFIX?=/usr/local
SRCS=src
HDRS=$(addsuffix .h,$(PROJECTS))
OBJS=$(addsuffix .o,$(PROJECTS))
DOCS?=share/doc/$(LIBNAME)
LIBS?=lib
INCLUDES?=include
MANS?=man/man1

all: $(PLIBS)

# $(SRCS)/$(PLIBNAME).o: $(SRCS)/*.c
# 	$(CC) $(CFLAGS) -c -o $@ $^

$(SRCS)/%.o: $(SRCS)/%.c
	$(CC) -c $(CFLAGS) -o $@ $<

$(PLIBSTATIC): $(addprefix $(SRCS)/,$(OBJS))
	$(AR) rcs $@ $^

# $(PLIBSHARED): $(SRCS)/libsais.o $(SRCS)/libsais64.o
# 	$(CC) $(CFLAGS) -shared -Wl,-soname,$@ $^ -o $@

clean:
	$(RM) $(OBJS) $(PLIBS)

install:
	$(INSTALL) -d $(PREFIX)/$(LIBS)
	$(INSTALL) -d $(PREFIX)/$(INCLUDES)
	$(INSTALL) -d $(PREFIX)/$(MANS)
	$(INSTALL) -d $(PREFIX)/$(DOCS)
	$(INSTALL) -m 0644 $(PLIBS) $(PREFIX)/$(LIBS)
	$(INSTALL) -m 0644 $(addprefix $(SRCS)/,$(HDRS)) $(PREFIX)/$(INCLUDES)
	$(INSTALL) -m 0644 CHANGES LICENSE README.md VERSION $(PREFIX)/$(DOCS)

uninstall:
	$(RM) $(PREFIX)/$(LIBS)/$(PLIBSTATIC)
	$(RM) $(PREFIX)/$(LIBS)/$(PLIBSHARED)
	$(RM) $(PREFIX)/$(INCLUDES)/$(SRCS)/$(PLIBNAME).h
	$(RMD) $(PREFIX)/$(DOCS)
