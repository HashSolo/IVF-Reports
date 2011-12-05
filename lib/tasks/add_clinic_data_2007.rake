require 'csv'

namespace :db do
  desc "Fill database with structure data."
  task :add_clinic_data_2007 => :environment do
  #need to import the chromosome CSV file here...
  #create a chromosome from the imported data...
  chrom_array = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y"]
  cur_chrom = 0
  while cur_chrom < 1
  chrom_string = chrom_array[cur_chrom]
	CSV.foreach("#{::Rails.root}/lib/tasks/gts/chr#{chrom_string}_structures.csv") do |row|
		cur_transcript = Transcript.find_by_ensembl_transcript_id("#{row[0]}")
		transcript_id = cur_transcript.id
		
		make_gene = 1
		
		cur_transcript.structures.each do |s|
			if s.structure_number == row[6]
				make_gene = 0
			end
		end
		
		if make_gene == 1
			Structure.create!(	
							:transcript_id => transcript_id,
							:structure_number => row[6],
							:start_position => row[3],
							:end_position => row[4],
							:structure_type => row[5]
							)
			puts "Just added structure #{row[6]} for the gene #{row[1]} in Chromosome #{chrom_string}."
		end
		
	end
	cur_chrom+=1
  end
  end
end