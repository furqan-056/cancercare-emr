class AppointmentMailer < ApplicationMailer
  default from: "no-reply@cancercare-emr.com"

  def created(appointment)
    @appointment = appointment
    mail(
      to: recipients,
      subject: "New Appointment Booked (#{appointment.status.titleize})"
    )
  end

  def status_changed(appointment)
    @appointment = appointment
    mail(
      to: recipients,
      subject: "Appointment #{appointment.status.titleize}"
    )
  end

  def updated_by_patient(appointment)
    @appointment = appointment
    mail(
      to: [appointment.doctor.email, appointment.patient.email],
      subject: "Appointment Updated by Patient"
    )
  end

  private

  def recipients
    [
      @appointment.patient.email,
      @appointment.doctor.email
    ]
  end
end
