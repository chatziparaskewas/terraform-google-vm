# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
num_instances = attribute('num_instances')

expected_compute_instances = 2
expected_reservation_instances = 1

expected_reservation_affinity_type = "SPECIFIC_RESERVATION"
expected_reservation_affinity_key = "compute.googleapis.com/reservation-name"
expected_reservation_affinity_value_size = 1
expected_reservation_affinity_value_0 = "compute-instance-reservation-affinity"

expected_reservation_count = "#{num_instances}"
expected_reservation_in_use_count = "#{num_instances}"

control "Compute Instances" do
  title "Reservation Affinity Configuration"

  describe command("gcloud --project=#{project_id} compute instances list --format=json --filter='name~compute-instance-reservation-affinity*'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        []
      end
    end

    describe "number of instances" do
      it "should be #{expected_compute_instances}" do
        expect(data.length).to eq(expected_compute_instances)
      end
    end

    describe "instance 001" do
      let(:instance) do
        data.find { |i| i['name'] == "compute-instance-reservation-affinity-001" }
      end

      it "should be in zone us-central1-a}" do
        expect(instance['zone']).to match(/.*us-central1-a$/)
      end

      it "should be reservation affinity type #{expected_reservation_affinity_type}" do
        expect(data[0]['reservationAffinity']['consumeReservationType']).to eq(expected_reservation_affinity_type)
      end

      it "should be reservation affinity key #{expected_reservation_affinity_key}" do
        expect(data[0]['reservationAffinity']['key']).to eq(expected_reservation_affinity_key)
      end

      it "should be reservation affinity values #{expected_reservation_affinity_value_size}" do
        expect(data[0]['reservationAffinity']['values'].length).to eq(expected_reservation_affinity_value_size)
      end

      it "should be reservation affinity value[0] #{expected_reservation_affinity_value_0}" do
        expect(data[0]['reservationAffinity']['values'][0]).to eq(expected_reservation_affinity_value_0)
      end
    end

    describe "instance 002 zone" do
      let(:instance) do
        data.find { |i| i['name'] == "compute-instance-reservation-affinity-002" }
      end

      it "should be in zone us-central1-a}" do
        expect(instance['zone']).to match(/.*us-central1-a$/)
      end

      it "should be reservation affinity type #{expected_reservation_affinity_type}" do
        expect(data[0]['reservationAffinity']['consumeReservationType']).to eq(expected_reservation_affinity_type)
      end

      it "should be reservation affinity key #{expected_reservation_affinity_key}" do
        expect(data[0]['reservationAffinity']['key']).to eq(expected_reservation_affinity_key)
      end

      it "should be reservation affinity values #{expected_reservation_affinity_value_size}" do
        expect(data[0]['reservationAffinity']['values'].length).to eq(expected_reservation_affinity_value_size)
      end

      it "should be reservation affinity value[0] #{expected_reservation_affinity_value_0}" do
        expect(data[0]['reservationAffinity']['values'][0]).to eq(expected_reservation_affinity_value_0)
      end
    end

  end

  describe command("gcloud --project=#{project_id} compute reservations list --format=json --filter='name~compute-instance-reservation-affinity*'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        []
      end
    end

    describe "reservation" do
      it "should be number of instances #{expected_reservation_instances}" do
        expect(data.length).to eq(expected_reservation_instances)
      end

      it "should have count #{expected_reservation_count}" do
        expect(data[0]['specificReservation']['count']).to eq(expected_reservation_count)
      end

      it "should have i-nuse count #{expected_reservation_in_use_count}" do
        expect(data[0]['specificReservation']['count']).to eq(expected_reservation_in_use_count)
      end
    end

  end
end
