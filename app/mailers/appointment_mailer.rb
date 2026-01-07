class AppointmentMailer < ApplicationMailer
  default from: "no-reply@yourapp.com"

  def notify_doctor(appointment)
    setup_appointment(appointment)

    mail(
      to: @doctor.email,
      subject: "New Appointment Scheduled"
    )
  end

  def notify_patient(appointment)
    setup_appointment(appointment)

    mail(
      to: @patient.email,
      subject: "Appointment Confirmation"
    )
  end

  def status_changed_doctor(appointment)
    setup_appointment(appointment)

    mail(
      to: @doctor.email,
      subject: "Appointment Status Updated"
    )
  end

  def status_changed_patient(appointment)
    setup_appointment(appointment)

    mail(
      to: @patient.email,
      subject: "Your Appointment Status Updated"
    )
  end

  def requested_by_patient_doctor(appointment)
    setup_appointment(appointment)

    mail(
      to: @doctor.email,
      subject: "New Appointment Request from #{@patient.full_name}"
    )
  end

  def requested_by_patient_confirmation(appointment)
    setup_appointment(appointment)

    mail(
      to: @patient.email,
      subject: "Your Appointment Request Has Been Sent"
    )
  end

  private

  def setup_appointment(appointment)
    @appointment = appointment
    @doctor      = appointment.doctor
    @patient     = appointment.patient
  end
end
