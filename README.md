# पाहा आणि कमवा: सेटअप (मोफत, डोमेन नको)

## 1) डेटाबेस (Supabase, मोफत)
1. supabase.com वर खाते उघडा, New project बनवा.
2. SQL Editor उघडा, `setup.sql` ची सर्व सामग्री पेस्ट करा आणि Run करा.
3. Project Settings > API मधून **Project URL** आणि **anon public key** कॉपी करा.
4. `index.html` मध्ये `YOUR_SUPABASE_URL` आणि `YOUR_SUPABASE_ANON_KEY` च्या जागी ते पेस्ट करा.
5. (सोपे टेस्टिंगसाठी) Authentication > Providers > Email मध्ये "Confirm email" बंद करा.

## 2) होस्टिंग (मोफत, डोमेन नको)
- **Netlify Drop:** app.netlify.com/drop वर जा, `index.html` ड्रॅग/अपलोड करा. लगेच `xxxx.netlify.app` लिंक मिळते.
- किंवा GitHub Pages वापरा.

## 3) Offerzy जोडणे
- Offerzy डॅशबोर्डवरून मिळालेला iframe/script कोड `index.html` मधील `offerzySlot` मध्ये बसवा.
- युजर ओळखण्यासाठी `window.CURRENT_USER_ID` वापरा (Offerzy च्या `user_id` पॅरामीटरमध्ये).
- Offerzy ने ऑफर पूर्ण झाल्यावर पाठवलेला **postback URL** Supabase Edge Function ने स्वीकारून `points` वाढवला पाहिजे. हे मी पुढच्या टप्प्यात बनवून देईन, त्यासाठी Offerzy चे postback डॉक्स लागतील.

## महत्त्वाचे
- हा सध्याचा व्हिडिओ फक्त डेमो आहे. खरे पैसे Offerzy कडून येतील तेव्हाच युजरना पेमेंट द्या.
- पॉइंट्स क्लेम सर्व्हरवर 60 सेकंद बंधनासह आहे, त्यामुळे युजर थेट पॉइंट्स बदलू शकत नाही.
