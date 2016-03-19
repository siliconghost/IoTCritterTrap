#require "Twilio.class.nut:1.0.0"

/**
 * @file    iot_crittertrap.agent.nut
 * @brief   Agent code for the IoT Critter Trap
 * @author  John Mangan (ManganLabs.com)
 *
 * @copyright	This code is public domain but you buy me a beer if you use
 * this and we meet someday (Beerware license).
 *
 * This agent code is responsible for sending a SMS message immediately
 * on start-up and every hour thereafter until the trap has been reset or
 * the batteries die.
 *
 * Relies on the Twilio library written by Electric Imp.
 */

/* INFO YOU NEED FROM TWILIO */
const TWILIO_SID = "ENTER YOURS HERE";
const TWILIO_AUTH = "ENTER YOURS HERE";
const TWILIO_NUM = "ENTER YOURS HERE";    // The number assigned to you by Twilio

const SEND_TO = "ENTER YOURS HERE";   // Number to send text message to

twilio <- Twilio(TWILIO_SID, TWILIO_AUTH, TWILIO_NUM);

numberToSendTo <- SEND_TO;
message <- "Critter Caught!";

function sendSMS(time) {
    
     // Update the time using imp's RTC
    local now = date();
    local seconds = format("%.2u", now.sec);    
    local minutes = format("%.2u", now.min);
    local hours = now.hour;
    // subtract 4 hours for EST. Adjust as needed for your timezone
    hours = format("%.2u", hours-4); 
    local currenttime = hours + ":" + minutes + ":" + seconds;
    
    // Send the SMS message
    local response = twilio.send(numberToSendTo, message + " - " + currenttime)
    server.log(response.statuscode + ": " + response.body)

    // Put the Imp to deep sleep for X seconds
    device.send("snooze", 3600);
    
}

// Enter our sendSMS function after Imp is connected to Wifi and happy
device.on("sendSMS", sendSMS);

