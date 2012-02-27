namespace :db do

  namespace :mongoid do
    desc 'Regenerates the auto-increments defined on your mongoid models'
    task :regenerate_auto_increments => :environment do
      puts 'Regenerating Mongoid::AutoIncrement'
      Mongoid::AutoIncrement::Sequence.delete_all
      
      get_mongoid_models.select do |klass|
        # skip unless has auto-increment
        next unless klass.included_modules.include?(Mongoid::AutoIncrement)

        # skip if auto-increment is defined in a parent class with the same collection name
        # (since we handle it there already and would double count it)
        parent_klass = nil
        parent_klasses = klass.ancestors - klass.included_modules - [klass]
        parent_klasses.each do |pk|
          if pk.included_modules.include?(Mongoid::AutoIncrement) and pk.collection == klass.collection
            parent_klass = pk
            break
          end
        end
        if parent_klass
          puts "Skipping #{klass} because #{parent_klass} already handels the auto-increment"
          next
        end

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