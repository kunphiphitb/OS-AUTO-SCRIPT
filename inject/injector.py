import socket, sys, os, select, thread, ConfigParser, time 
path = os.path.join(sys.path[0], 'Cnfig.ini')
config = ConfigParser.ConfigParser()
config.read('%s' % (path)) 
LP = config.get('GENERAL','ListenPort')
B = config.get('GENERAL','Buffer')
K = config.get('GENERAL','KET')
Ket = '%s' %K
Ket = Ket.replace('#;','\r\n')
print Ket + '\n6. Manual\n'
time.sleep(0.5)
Profil = raw_input ('Enter No: ')
if Profil == '1':
    Proxy = config.get('PROFIL 1','Proxy')
    Payload = config.get('PROFIL 1','Payload')
    print 'Menggunakan Profil 1'
elif Profil == '2':
    Proxy = config.get('PROFIL 2','Proxy')
    Payload = config.get('PROFIL 2','Payload')
    print 'Menggunakan Profil 2'
elif Profil == '3':
    Proxy = config.get('PROFIL 3','Proxy')
    Payload = config.get('PROFIL 3','Payload') 
    print 'Menggunakan Profil 3'
elif Profil == '4':
    Proxy = config.get('PROFIL 4','Proxy')
    Payload = config.get('PROFIL 4','Payload')
    print 'Menggunakan Profil 4'
elif Profil == '5':
    Proxy = config.get('PROFIL 5','Proxy')
    Payload = config.get('PROFIL 5','Payload')
    print 'Menggunakan Profil 5'
elif Profil == '6':
    ML = raw_input("Listen Port      : ")
    MB = raw_input("Buffer           : ")
    MP = raw_input("Proxy (host:port): ")
    MPay = raw_input("Payload          : ")
else:
    Proxy = config.get('PROFIL 1','Proxy')
    Payload = config.get('PROFIL 1','Payload')
    print 'Default Menggunakan Profil 1'
if Profil == '6':
   LP = ML
   B = MB
   Proxy = MP
   Payload = str(MPay)
Pay = Payload.replace('%0D','\r')
Pay = Pay.replace('%0A','\n')
Pay = Pay.replace('[cr]','\r')
Pay = Pay.replace('[lf]','\n')
Pay = Pay.replace('[crlf]','\r\n')
Pay = Pay.replace('[lfcr]','\n\r')
Pay = Pay.replace('[crlf*2]','\r\n\r\n')
Pay = Pay.replace('[crlf"3]','\r\n\r\n\r\n')
Pay = Pay.replace('[protocol]','HTTP/1.1')
Pay = Pay.replace('#','\r')
Pay = Pay.replace(';','\n')
time.sleep(0.5)
print '\n[MODE INJECT]\n1. Front Inject\n2. Back Inject \n'
time.sleep(0.5)
menu = raw_input('Enter No:  ')
if menu == '1':
    Po = 1
    print 'Menggunakan Mode Front Inject'
elif menu == '2':
    Po = 2
    print 'Menggunakan Mode Back Inject'
else:
            sys.exit()
class injector:
    def __init__(self, request, address):
        self.client = request
        self.Target_Host = None
        self.client_id = address
        self.AThread_NetData = self.client.recv(int(B))
        if self.AThread_NetData:
           if self.firewall(self.AThread_NetData):
              if 'HTTP/1.0' in self.AThread_NetData.splitlines()[0] and self.AThread_NetData.startswith('CONNECT'):
                  self.client.send('HTTP/1.0 200 Connection Established\r\n\r\n')
                  self.Run_Programs()
              else:
                  self.Run_Programs()
    def __del__(self):
        self.client.close()
    def Run_Programs(self): 
        if  Po == 1:
            arbitrary_data = '%s%s' % (Pay, self.AThread_NetData)
        elif Po == 2:
            arbitrary_data = '%s%s' % (self.AThread_NetData, Pay) 
        else:
            sys.exit()
        self.Target_Host = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
        i = Proxy.find(':')
        if i >= 0:
            host_port = (Proxy[:i], int(Proxy[i + 1:]))
        try:
            self.Target_Host.connect((host_port))
        except socket.error:
            self.client.close()
            self.Target_Host.close()
        except socket.timeout:
            self.Target_Host.close()
            print 'PROXY SOCKET TIMEOUT\n'
        else:
            self.Target_Host.send('%s' % arbitrary_data)
            self.request_log(self.AThread_NetData)
            self.start = time.clock()
            self.handledata()
    def handledata(self, max_waiting = 60):
        socs = [self.Target_Host, self.client]
        count = 0
        while True:
            count += 1
            recv, _, error = select.select(socs, [], socs, 3)
            if error:
                break
            if recv:
                for bite in recv:
                    out = None
                    try:
                        pack = bite.recv(int(B))
                        data = pack.replace('Connection: Close', 'Connection: Keep-Alive')
                    except socket.error:
                        break
                    if data:
                        if bite is self.client:
                            if self.firewall(data):
                                out = self.Target_Host
                        elif bite is self.Target_Host:
                            out = self.client
                            self.response(data)
                        else:
                            break
                    else:
                        accept = False
                    if out:
                        out.send(data)
                        count = 0
            if count == max_waiting:
                break
        return
    def request_log(self, data):
        logging = repr(data)
        print '+++++Request+++++\n%s\n' %logging
    def response(self, data):
        if 'HTTP' in data.splitlines()[0]:
            logging = repr(data)
            print '+++++Response+++++\n%s\n' %logging
    def firewall(self, data):
        url = data.splitlines()[0]
        return True
def main(handler = injector):
    time.sleep(0.5)
    print '\n[CONFIG]\nListen Port: %s\nBuffer     : %s\nProxy      : %s\nPayload: %s\n\nInjector ready>>>' % (LP, B, Proxy,Payload)
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        s.bind(('127.0.0.1', int(LP)))
    except socket.error:
        s.close()
        print '-Error: address already in use'
    else:
        s.listen(0)
        while True:
            try:
                thread.start_new_thread(handler, s.accept())
            except KeyboardInterrupt:
                s.close()
                os.abort()
if __name__ == '__main__':
    main()