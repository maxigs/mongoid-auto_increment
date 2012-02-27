namespace :db do

  namespace :mongoid do
    desc 'Regenerates the auto-increments defined on your mongoid models'
    task :regenerate_auto_increments => :environment do
      puts 'Regenerating Mongoid::AutoIncrement'
      Mongoid::AutoIncrement::Sequence.delete_all
      
      get_mongoid_models.select do |klass|
        if klass.ancestors.include?(Mongoid::AutoIncrement)
          i = 0
          klass.all.each do |record|
            record._mongoid_auto_increment_set__i(true)
            i += 1
          end
          
          puts "Updated #{i} documents for #{klass}"
        end
      end
    end
  end

end