# Define directories
DATA_DIR=data
RESULTS_DIR=results
FIGURE_DIR=$(RESULTS_DIR)/figure
SCRIPTS_DIR=scripts
REPORT_DIR=report

# Define input and output files
TEXT_FILES=$(DATA_DIR)/abyss.txt $(DATA_DIR)/isles.txt $(DATA_DIR)/last.txt $(DATA_DIR)/sierra.txt
RESULTS_FILES=$(RESULTS_DIR)/abyss.dat $(RESULTS_DIR)/isles.dat $(RESULTS_DIR)/last.dat $(RESULTS_DIR)/sierra.dat
PLOTS=$(FIGURE_DIR)/abyss.png $(FIGURE_DIR)/isles.png $(FIGURE_DIR)/last.png $(FIGURE_DIR)/sierra.png
REPORT_OUTPUT=$(REPORT_DIR)/count_report.html

# Ensure the necessary directories exist before starting the process
$(shell mkdir -p $(RESULTS_DIR) $(FIGURE_DIR))

# Default target to run everything
all: count_words create_plots generate_report

# Target to count words for all novels
count_words: $(RESULTS_FILES)
$(RESULTS_DIR)/%.dat: $(DATA_DIR)/%.txt
	@echo "Counting words for $<..."
	python $(SCRIPTS_DIR)/wordcount.py --input_file=$< --output_file=$@

# Target to create plots for all the novels
create_plots: $(PLOTS)
$(FIGURE_DIR)/%.png: $(RESULTS_DIR)/%.dat
	@echo "Creating plot for $<..."
	python $(SCRIPTS_DIR)/plotcount.py --input_file=$< --output_file=$@

# Target to generate the report
generate_report: $(REPORT_OUTPUT)
$(REPORT_OUTPUT): $(REPORT_DIR)/count_report.qmd
	@echo "Generating the report..."
	quarto render $(REPORT_DIR)/count_report.qmd

# Clean target to reset the pipeline
clean:
	@echo "Cleaning up the results..."
	rm -rf $(RESULTS_DIR) $(FIGURE_DIR) $(REPORT_OUTPUT)  # Delete generated files
	@echo "Restoring the data files to their original state..."
	# Ensure that text files are reset to their original state via git
	git checkout -- $(TEXT_FILES)
	@echo "The repository has been reset to its initial state."

# Additional useful targets
.PHONY: all count_words create_plots generate_report clean


