class AppointmentMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def notify_doctor(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient
    mail(to: @doctor.email, subject: "New Appointment Scheduled")
  end

  def notify_patient(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient
    mail(to: @patient.email, subject: "Appointment Confirmation")
  end

  def status_changed_doctor(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient
    mail(to: @doctor.email, subject: "Appointment Status Updated")
  end

  def status_changed_patient(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient
    mail(to: @patient.email, subject: "Your Appointment Status Updated")
  end

  def requested_by_patient_doctor(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient

    mail(
      to: @doctor.email,
      subject: "New Appointment Request from #{@patient.full_name}"
    )
  end

  def requested_by_patient_confirmation(appointment)
    @appointment = appointment
    @doctor = appointment.doctor
    @patient = appointment.patient

    mail(
      to: @patient.email,
      subject: "Your Appointment Request Has Been Sent"
    )
  end
end
