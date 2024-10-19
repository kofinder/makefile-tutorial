# TARGETS - prerequisites

# CC: program for compiling C programs - default cc
# CXX: program for compiling C++ programs - default g++
# CFLAGS: Extra flags to give to the C compiler
# CXXFLAGS: Extra flags to give to the C++ compiler
# CPPFLAGS: Extra flags to give to the C preprocessor
# LDFLAGS: Extra flags to give to the linker

# Variables can only be strings
# Single or double quotes for variable name or value have no meaning to Make

DEBUG ?= 1
ENABLE_WARNING ?= 1
WARNINGS_AS_ERROR ?= 0

INCLUDE_DIR = include
SOURCE_DIR = src
BUILD_DIR = build

CXX_STANDARD = c++20

ifeq ($(ENABLE_WARNING), 1)
CXX_WARNINGS = -Wall -Wextra -Wpedantic
else
CXX_WARNINGS =
endif

ifeq ($(WARNINGS_AS_ERROR), 1)
CXX_WARNINGS += -Werror
endif

CXX = g++
CFLAGS = $(CXX_WARNINGS) -std=$(CXX_STANDARD)
CPPFLAGS = -I $(INCLUDE_DIR)
LDFLAGS = # Add linker flags here if needed

ifeq ($(DEBUG), 1)
CXXFLAGS = $(CFLAGS) -g -O0
EXECUTABLE_NAME = mainRelease
else
CXXFLAGS = $(CFLAGS) -O3
EXECUTABLE_NAME = mainDebug
endif

COMPILER_CALL = $(CXX) $(CXXFLAGS) $(CPPFLAGS)

# Collect source files and generate object files list
CXX_SOURCES = $(wildcard $(SOURCE_DIR)/*.cc)
CXX_OBJECTS = $(patsubst $(SOURCE_DIR)/%.cc, $(BUILD_DIR)/%.o, $(CXX_SOURCES))


all: build

create:
	@mkdir -p build

# Build target
build: create $(CXX_OBJECTS)
	$(COMPILER_CALL) $(CXX_OBJECTS) $(LDFLAGS) -o $(BUILD_DIR)/$(EXECUTABLE_NAME)

# Execute the program
execute:
	./$(BUILD_DIR)/$(EXECUTABLE_NAME)

# Clean up build artifacts
clean:
	rm -f $(BUILD_DIR)/*.o
	rm -f $(BUILD_DIR)/$(EXECUTABLE_NAME) 

# PATTERNS
# $@ : file name of the target (the file that the rule will generate)
# $< : the name of the first dependency (usually the source file being compiled)
# $^ : the names of all the prerequisites (all dependencies, including headers or other files)
# %  : pattern matching for target and dependency names
#       - A wildcard that matches any string of characters.
#       - Used in pattern rules to define generic build rules.

# Pattern rule for generating object files from source files
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.cc
	$(COMPILER_CALL) -c $< -o $@

# PHONY targets
.PHONY: all create build execute clean
