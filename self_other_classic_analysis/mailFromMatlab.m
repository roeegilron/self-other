function mailFromMatlab(title, msg)


sender = 'roeefrommatlab@gmail.com' ;                % Replace with your email address
psswd = 'mailfrommatlab';                    % Replace with your email password


setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('roeegilron@gmail.com', title, msg);
