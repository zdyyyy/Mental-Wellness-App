max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# IPv4 only — avoids Windows ::1 EACCES; default 3000 (8081 is often used by Spring Boot)
bind "tcp://127.0.0.1:#{ENV.fetch('PORT', 3000)}"
environment ENV.fetch("RAILS_ENV", "development")
plugin :tmp_restart
