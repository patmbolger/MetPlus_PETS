class JobApplicationsController < ApplicationController
	include JobApplicationsViewer

	before_action :find_application

	def accept
		unless @job_application.active?
			flash[:alert] = "Invalid action on inactive job application."
		else
			@job_application.accept
			Event.create(:APP_ACCEPTED, @job_application) if @job_application.job_seeker.job_developer
			flash[:info] = "Job application accepted."
		end
		redirect_to applications_job_url(@job_application.job)
	end

	def reject
		unless @job_application.active?
			if request.xhr?
				render json: {message: "Cannot reject an inactive job application",
											status: 405}
			else
				flash[:alert] = "Cannot reject an inactive job application."
				redirect_to applications_path(@job_application)
			end
		else
			@job_application.reason_for_rejection = params[:reason_for_rejection]
			@job_application.save
			@job_application.reject
			Event.create(:APP_REJECTED, @job_application) if @job_application.job_seeker.job_developer

			if request.xhr?
				render json: {message: "Job application rejected", status: 200}
			else
				flash[:notice] = "Job application rejected."
				redirect_to controller: 'jobs', action: 'applications',
										id: @job_application.job.id
			end
		end
	end

	def show
	end

	def find_application
		begin
			@job_application = JobApplication.find(params[:id])
		rescue
			flash[:alert] = "Job Application Entry not found."
			redirect_back_or_default
		end
	end

	def download_resume
		begin
			job_application = JobApplication.find(params[:id])
			job_seeker = job_application.job_seeker
			resume = job_seeker.resumes[0]
			resume_file = ResumeCruncher.download_resume(resume.id)
			# original_file_name = resume.file_name
			# transfer_file = File.new(File.dirname(tempfile) + '/' + original_file_name)
			# transfer_file.write tempfile.read
			path = '#{Rails.root}/tmp/#{resume_file}'
		  send_data(path,
		    type: 'application/#{extension[1]}',
		    disposition: 'inline',
		    x_sendfile: true)

		rescue
			flash[:alert] = "Resume not found."
			redirect_back_or_default

		ensure
			resume_file.close
			resume_file.unlink
		end

	end

end
