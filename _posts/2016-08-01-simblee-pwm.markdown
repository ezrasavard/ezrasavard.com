---
title:  Configuring 16-bit PWM on a Simblee (RFD77101)
date:   2016-08-01
tags: [headboard, projects]
---

I was tinkering around with my partner's [LED wake-up light project](http://lisesavard.com/wake-up-light/) and decided to try upgrading her PWM to a super smooth 16-bit version. Her original code used the Arduino analogWrite() method and worked quite well at higher values, but zero to one was a bit of a jump.

<!--more-->

<img alt="Sparkfun Simblee Board" src="{{site.baseurl}}/media/simblee.jpg">

Simblee is a low-energy bluetooth (BLE) enabled chip with an ARM M0 inside. Documentation focuses mostly on using its own mobile app to interact with the device through customizable GUIs. On the hardware front, the Simblee is not a very well documented product, and everyone seems to pass around [the same code snippet](http://forum.rfduino.com/index.php?topic=155.0) for using a 16-bit timer to generate an even square wave. For that reason, I made this post about configuring TIMER2 with a variable duty cycle square wave suitable for PWM.

### Here is my code:

Configure the timers:

{% highlight C  linenos %}
#define PWM16_MAX_VAL 65535
const int led = 2; // the on-board LED pin, configured as output in other code

//configure timer2 for 16 bit PWM usage
void timer_config() {

  NRF_TIMER2-&gt;TASKS_STOP = 1;
  NRF_TIMER2-&gt;MODE = TIMER_MODE_MODE_Timer;
  NRF_TIMER2-&gt;BITMODE = TIMER_BITMODE_BITMODE_16Bit;
  NRF_TIMER2-&gt;PRESCALER = 1; // divide frequency down by 2^x
  NRF_TIMER2-&gt;TASKS_CLEAR = 1; // Clear timer
  NRF_TIMER2-&gt;INTENSET |= TIMER_INTENSET_COMPARE0_Enabled &lt;&lt; TIMER_INTENSET_COMPARE0_Pos;
  NRF_TIMER2-&gt;INTENSET |= TIMER_INTENSET_COMPARE1_Enabled &lt;&lt; TIMER_INTENSET_COMPARE1_Pos;
  NRF_TIMER2-&gt;CC[0] = PWM16_MAX_VAL; // this is related to a bug fix, see "my_isr()" comments
  NRF_TIMER2-&gt;CC[1] = 0;
  NRF_TIMER2-&gt;EVENTS_COMPARE[0] = 0;
  NRF_TIMER2-&gt;EVENTS_COMPARE[1] = 0;
  dynamic_attachInterrupt(TIMER2_IRQn, my_isr);
}
{% endhighlight %}

The ISR:

{% highlight C  linenos %}

void my_isr(void) {

 if (NRF_TIMER2-&gt;EVENTS_COMPARE[0] != 0) {
   NRF_TIMER2-&gt;EVENTS_COMPARE[0] = 0;
   digitalWrite(led, HIGH);
 }
 else if (NRF_TIMER2-&gt;EVENTS_COMPARE[1] != 0) {
   NRF_TIMER2-&gt;EVENTS_COMPARE[1] = 0;
   digitalWrite(led, LOW);
 }
}

{% endhighlight %}

The function to call:

{% highlight C  linenos %}

void pwm16(uint16_t value) {

  NRF_TIMER2-&gt;TASKS_STOP = 1;
  NRF_TIMER2-&gt;EVENTS_COMPARE[0] = 0;
 
  if (value == 0) {
    digitalWrite(led, LOW);
  }
  else if (value == PWM16_MAX_VAL) {
    digitalWrite(led, HIGH);
  }
  else {
    NRF_TIMER2-&gt;CC[0] = PWM16_MAX_VAL - value;
    NRF_TIMER2-&gt;TASKS_START = 1;
  }
}
{% endhighlight %}

Some extra *bits* of caution though!

 * TIMER2 is not a real-time clock and use of the wireless radio will introduce some pretty big delays (~5 ms at times). I found disabling the radio before PWM and re-enabling it after was a good workaround, but that is because my application doesn't need to use the radio during PWM.
 * This implementation shows some minor occasional jitter that I haven't figured out yet. It is probably due to system interrupts on TIMER0, but I need the delay() function in my application so I think I just have to live with it.

I hope someone finds that useful =)

### Addendum - Three channel PWM with one timer

After discussing some things, one of my co-workers decided to implement an RGB LED controller using a variation on this method by setting the all four CC values. One triggers on overflow while the other three are each colour channel's value. He also added a global flag to set for any of the channels sharing the same value. In the ISR, the EVENTS_COMPARE and this global flag are used to determine which colour(s) triggered the ISR and set their pin values accordingly.
