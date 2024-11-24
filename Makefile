# Compiler and flags
CC = nvcc -O2 -arch=sm_30

# Directories
SOURCE_DIR = src
BUILD_DIR = build

# Files
SRC_FILES = $(wildcard $(SOURCE_DIR)/*.c)
OUT_FILE = $(BUILD_DIR)/aes

# Default target
all: $(OUT_FILE)

# Ensure build directory exists
$(BUILD_DIR):
	mkdir -pv $(BUILD_DIR)

# Build the final executable
$(OUT_FILE): $(SRC_FILES) | $(BUILD_DIR)
	$(CC) $(SRC_FILES) -o $(OUT_FILE)

# Clean build files
clean:
	rm -rf $(BUILD_DIR)

# Phony targets
.PHONY: all clean
