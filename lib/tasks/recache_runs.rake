task recache_runs: :environment do
  jobs = Delayed::Job.where("queue = 'cache_csv' and now() - run_at > interval '10 minutes'")
  job_ids = jobs.collect(&:id)

  jobs.each do |job|
    run = job.payload_object.object
    print "Processing run with ID #{run.id}... "

    run.cache_csv_data_row
    puts "done"
  end

  Delayed::Job.where(id: job_ids).delete_all
end
