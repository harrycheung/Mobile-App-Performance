#
# Copyright (c) 2015 Harry Cheung
#

SDK := iphonesimulator
J2OBJC_HOME := /Users/harry/Projects/src/j2objc-0.9.6.1
SRC_DIR := Java/src/main/java
TST_DIR := Java/src/test/java
TEST_BIN := j2objcTest
CLASSPATH := $(J2OBJC_HOME)/lib/j2objc_guava.jar:$(J2OBJC_HOME)/lib/j2objc_annotations.jar:$(J2OBJC_HOME)/lib/junit-4.10.jar:Java/lib/json-20090211.jar
PREFIX := HCM
SRC_FILES := $(subst $(SRC_DIR)/, , $(shell find -L "$(SRC_DIR)" -name '*.java' -type f))
SRC_FOLDERS := $(sort $(dir $(addprefix $(SRC_DIR)/, $(SRC_FILES))))
TST_FILES := $(subst $(TST_DIR)/, , $(shell find -L "$(TST_DIR)" -name '*Test.java' -type f))
TST_FOLDERS := $(sort $(dir $(addprefix $(TST_DIR)/, $(TST_FILES))))
TESTS := $(subst .java,,$(notdir $(TST_FILES)))
DERIVED_FILES_DIR := j2objc_generated
BUILD_DIR := $(DERIVED_FILES_DIR)
J2OBJC_FLAGS := --no-package-directories -d $(BUILD_DIR) -sourcepath $(SRC_DIR):$(TST_DIR) -classpath $(CLASSPATH) --prefix harrycheung.map.shared=HCM
OBJC_FILES := $(addprefix $(BUILD_DIR)/, $(notdir $(SRC_FILES:.java=.m))) $(addprefix $(BUILD_DIR)/, $(notdir $(TST_FILES:.java=.m)))

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
	@rm $(BUILD_DIR)/*
	@rm -r $(TEST_BIN) $(TEST_BIN).dSYM

$(TEST_BIN): $(OBJC_FILES) $(OBJC_HEADERS)
	@echo "Building test executable..."; \
	${J2OBJC_HOME}/j2objcc -g -ObjC -o $@ -I$(BUILD_DIR) -ljunit -lguava -ljsr305 $(OBJC_FILES)

$(TESTS): $(TEST_BIN)
	@echo "Running $@..."; \
	./$(TEST_BIN) org.junit.runner.JUnitCore $(PREFIX)$@

test: translate $(TESTS)