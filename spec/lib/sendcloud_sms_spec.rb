require 'spec_helper'

describe SendCloud::SMS do
  before do
    SendCloud::SMS.auth('testing_user', '6qvnSHlZlX0ENzGbLv2CiXiVZN29m0jV')
  end

  describe '.send_sms' do
    before do
      stub_request(:post, 'http://sendcloud.sohu.com/smsapi/send')
        .to_return(**response)
    end

    def send_sms
      SendCloud::SMS.send_sms(65_432, phone_number, var1: 'test1', var2: 'test2')
    end

    context 'when request is successful' do
      let(:phone_number) { '14585282006' }
      let(:response) do
        {
          status: 200,
          body: {
            'result' => true,
            'statusCode' => 200,
            'message' => '请求成功',
            'info' => {
              'successCount' => 1,
              'smsIds' => ['2738391923535_556569_89854_105470_qZpeg9$14585282006']
            }
          }.to_json,
          headers: {}
        }
      end

      it 'sends request to Sendcloud SMS API and return response' do
        return_value = send_sms

        expect(a_request(:post, 'http://sendcloud.sohu.com/smsapi/send').with(
                 body: {
                   'msgType' => '0',
                   'phone' => '14585282006',
                   'signature' => '074b87721854e17125275d9c0d5e10fb',
                   'smsUser' => 'testing_user',
                   'templateId' => '65432',
                   'vars' => '{"var1":"test1","var2":"test2"}'
                 }
               )).to have_been_made.once

        expect(return_value).to eq({
          'successCount' => 1,
          'smsIds' => ['2738391923535_556569_89854_105470_qZpeg9$14585282006']
        })
      end
    end

    context 'when request is failed' do
      let(:phone_number) { '97926481168' }
      let(:response) do
        {
          status: 200,
          body: {
            'result' => false,
            'statusCode' => 412,
            'message' => '手机号格式错误',
            'info' => {}
          }.to_json,
          headers: {}
        }
      end

      it 'raises send error' do
        expect {
          send_sms
        }.to raise_error(SendCloud::SMS::SendError)
      end
    end
  end

  describe '.send_voice' do
    before do
      stub_request(:post, 'http://sendcloud.sohu.com/smsapi/sendVoice')
        .to_return(
          status: 200,
          body: {
            'result' => true,
            'statusCode' => 200,
            'message' => '请求成功',
            'info' => {
              'successCount' => 1,
              'smsIds' => ['1612786681010_101844_13590_198159_uDPrmg$14585282006']
            }
          }.to_json,
          headers: {}
        )
    end

    it 'sends request to Sendcloud Voice Verification Code API' do
      SendCloud::SMS.send_voice('14585282006', '666337')

      expect(a_request(:post, 'http://sendcloud.sohu.com/smsapi/sendVoice').with(
               body: {
                 'code' => '666337',
                 'phone' => '14585282006',
                 'signature' => 'f1aa078336fe6858edcb07f73ded09ef',
                 'smsUser' => 'testing_user'
               }
             )).to have_been_made.once
    end
  end
end
