#
# Copyright (c) 2015 Harry Cheung
#

SDK := iphonesimulator
J2OBJC_HOME := /Users/harry/Projects/src/j2objc-0.9.6.1
SRC_DIR := Java/src/main/java
TST_DIR := Java/src/test/java
TEST_BIN := j2objc_test
CLASSPATH := $(J2OBJC_HOME)/lib/j2objc_annotations.jar:$(J2OBJC_HOME)/lib/junit-4.10.jar:Java/lib/json-20090211.jar
PREFIX := HCM

# Find all files in SRC_DIR, but remove SRC_DIR from the paths
SRC_FILES := $(subst $(SRC_DIR)/, , $(shell find "$(SRC_DIR)" -name '*.java' -type f))
SRC_FOLDERS := $(sort $(dir $(addprefix $(SRC_DIR)/, $(SRC_FILES))))
TST_FILES := $(subst $(TST_DIR)/, , $(shell find "$(TST_DIR)" -name '*Test.java' -type f))
TST_FOLDERS := $(sort $(dir $(addprefix $(TST_DIR)/, $(TST_FILES))))
DERIVED_FILES_DIR := j2objc_generated

ifeq ($(BUILD_CONFIGURATION), Debug)
	J2OBJC_FLAGS += -g
endif

BUILD_DIR := $(DERIVED_FILES_DIR)
JAVAC_FLAGS := -d $(BUILD_DIR) -sourcepath $(SRC_DIR): -classpath $(CLASSPATH)
J2OBJC_FLAGS += --no-package-directories --prefix harrycheung.map=$(PREFIX) $(JAVAC_FLAGS)
# Flatten the list of Objective-C files as! that is how Xcode will expect them
OBJC_FILES := $(addprefix $(BUILD_DIR)/, $(notdir $(SRC_FILES:.java=.m)))
vpath %.java $(SRC_FOLDERS)
vpath %.java $(TST_FOLDERS)

OBJC_HEADERS := $(OBJC_FILES:.m=.h)

TRANSLATE_LIST=$(BUILD_DIR)/.translate_list

.PHONY: clean init-translate-list show  $(TESTS)

default: translate

translate: $(BUILD_DIR) init-translate-list $(OBJC_FILES) $(OBJC_HEADERS)
	@if [ -s $(TRANSLATE_LIST) ]; then \
		xargs "$(J2OBJC_HOME)/j2objc" $(J2OBJC_FLAGS) < "$(TRANSLATE_LIST)"; \
	fi
	@rm -f "$(TRANSLATE_LIST)"

$(BUILD_DIR)/%.m $(BUILD_DIR)/%.h: %.java
	@echo $< >> "$(TRANSLATE_LIST)"

init-translate-list: $(BUILD_DIR)
	@rm -f "$(TRANSLATE_LIST)"
	@touch "$(TRANSLATE_LIST)"

$(BUILD_DIR):
	@mkdir -p "$(BUILD_DIR)"

clean:
	@rm -rf $(BUILD_DIR)

$(SRC_FILES):
	javac $(JAVAC_FLAGS) $(SRC_DIR)/$@

$(TST_FILES):
	javac $(JAVAC_FLAGS) $(TST_DIR)/$@

test: $(SRC_FILES) $(TST_FILES)
	java -classpath $(CLASSPATH) org.junit.runner.JUnitCore
